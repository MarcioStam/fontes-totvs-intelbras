/********************************************************************************
 ** UPC........: win111.p - UPC WRITE estrutura
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de estruturas para a Base Oracle
 ** Data.......: Fevereiro / 2023
 ** Objetivo...: UPC no en0109a
 ********************************************************************************/

DEF PARAM BUFFER b-estrutura      FOR estrutura.
DEF PARAM BUFFER b-old-estrutura  FOR estrutura.

{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
{upc/en0109a-upc.i}

/**/
DEFINE VARIABLE cNom_from        AS CHARACTER    NO-UNDO INITIAL ''.
DEFINE VARIABLE lErro            AS LOGICAL      NO-UNDO INITIAL NO.
DEFINE VARIABLE C-ALTERACAO      AS char format "x(35)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-atu     AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-ant     AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-programa       AS char format "x(40)" extent 3  no-undo initial ''.
DEFINE VARIABLE level            AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-estrutura      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mail          AS CHARACTER   NO-UNDO.
def var c-desc-usuario as char format "x(30)".

define buffer b-item  for item.
DEFINE BUFFER b1-item FOR ITEM.

def temp-table tt-pos
    field letra    as char format "X(15)"     
    field ord      as dec
    field pos      as char format "x(15)"  
    index tt-pos is primary unique 
          letra 
          ord
    index ordem 
          letra
          pos.

DEF TEMP-TABLE tt-int-estrutura
    FIELD es-codigo    LIKE estrutura.es-codigo
    FIELD fim-validade AS DATE
    FIELD garantia     LIKE int-estrutura.garantia 
    FIELD venda        LIKE int-estrutura.venda
    FIELD r-rowid      AS ROWID.

DEF VAR i-nivel AS INTEGER .
DEF BUFFER b-e FOR estrutura.
DEF BUFFER b-int-estrutura-aux FOR int-estrutura.

if  valid-handle(h-alternativo-en0109a-upc)
and h-alternativo-en0109a-upc:sensitive
and h-alternativo-en0109a-upc:checked    
and valid-handle(h-desativar-en0109a-upc)
and h-desativar-en0109a-upc:screen-value = "2"
and temp-table tt-en0109a-upc-ant:has-records
and not can-find(first tt-en0109a-upc-new where
                       tt-en0109a-upc-new.it-codigo = b-estrutura.it-codigo
                   and tt-en0109a-upc-new.sequencia = b-estrutura.sequencia
                   and tt-en0109a-upc-new.es-codigo = b-estrutura.es-codigo)
then do:
     create tt-en0109a-upc-new.
     assign tt-en0109a-upc-new.it-codigo    = b-estrutura.it-codigo
            tt-en0109a-upc-new.sequencia    = b-estrutura.sequencia
            tt-en0109a-upc-new.es-codigo    = b-estrutura.es-codigo
            tt-en0109a-upc-new.lg-new       = new b-estrutura.
     find current tt-en0109a-upc-new no-error.
     release tt-en0109a-upc-new.
end.

ASSIGN level = 1
       l-estrutura = NO.

REPEAT WHILE PROGRAM-NAME(level) <> ?:
    IF PROGRAM-NAME(level) MATCHES "*en0105*" THEN
        ASSIGN l-estrutura = YES.

    ASSIGN level = level + 1.
END.

RUN pi-cria-int-estrutura.

RUN pi-trata-int-local-montag.

/*Inicio Integra‡Æo*/
/* DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO                     */
/*     FIELD CodigoProduto LIKE estrutura.it-codigo.                  */
/* DEF VAR raw-param   AS RAW  NO-UNDO.                               */
/*                                                                    */
/* CREATE tt-estrutura-integra.                                       */
/* ASSIGN tt-estrutura-integra.CodigoProduto = b-estrutura.it-codigo. */
/*                                                                    */
/* RAW-TRANSFER tt-estrutura-integra TO raw-param.                    */
/*                                                                    */
/* RUN esp/trgw/wes727a.p (INPUT raw-param,                           */
/*                         INPUT 'msg0301').                          */
/*
IF NEW b-estrutura THEN DO:
    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = b-estrutura.it-codigo NO-ERROR.

    IF  AVAIL int-item
    AND int-item.nr-ped-energia <> "" THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "win111":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN c-mail = "".

        FOR EACH tt-prog-ponto:
            IF c-mail = "" THEN
                ASSIGN c-mail = tt-prog-ponto.conteudo.
            ELSE 
                ASSIGN c-mail = c-mail + ", " + tt-prog-ponto.conteudo.
        END.

        IF c-mail <> "" THEN DO:

            FOR FIRST param-global NO-LOCK:
            END.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
            
            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
      
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = c-mail                   /* Destinatÿrio       */ 
                   tt-envio2.remetente         = usuar_mestre.cod_e_mail_local  /* Remetente          */ 
                   tt-envio2.assunto           = "Gerador Fotovoltaico - Pedido " + int-item.nr-ped-energia /* Assunto */
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Prezado Colaborador(a)," + CHR(13) + CHR(13) + 
                                              "Foi cadastrado um novo Gerador Fotovoltaico, com o c¢digo " + int-item.it-codigo + "." + CHR(13) + 
                                              "Favor ajustar os dados fiscais do item, calcular seu FCI e libera-lo para faturamento." + CHR(13) + CHR(13) + 
                                              "Atenciosamente," + CHR(13) +
                                              "Central de Cadastros.".

            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
           
            FIND FIRST tt-erros NO-LOCK NO-ERROR.

/*             IF AVAIL tt-erros THEN DO:       */
/*                 PUT tt-erros.desc-erro SKIP. */
/*             END.                             */
            
            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.
        END.

    END.
END.
*/
PROCEDURE pi-cria-int-estrutura.

    DEFINE BUFFER b-int-estrut-ant  FOR int-estrutura.
          
    IF NEW b-estrutura THEN DO:
        
        /* Carregar a tt-int-estrutura */
        IF l-estrutura THEN
            RUN pi-estrutura (INPUT  b-estrutura.it-codigo).

        find first int-estrutura EXCLUSIVE-LOCK
             where int-estrutura.it-codigo = b-estrutura.it-codigo
               and int-estrutura.es-codigo = b-estrutura.es-codigo
               and int-estrutura.sequencia = b-estrutura.sequencia no-error.
        
        if not avail int-estrutura then do:
            /* Cria tt-int-estrutura */
            create int-estrutura.
            assign int-estrutura.it-codigo = b-estrutura.it-codigo
                   int-estrutura.es-codigo = b-estrutura.es-codigo
                   int-estrutura.sequencia = b-estrutura.sequencia.

            FIND FIRST b1-item WHERE
                       b1-item.it-codigo = b-estrutura.it-codigo
                       NO-LOCK NO-ERROR.

            IF AVAIL b1-item 
            THEN DO:

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "win111":U,
                                   INPUT 3,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).

                IF CAN-FIND(FIRST tt-prog-ponto WHERE
                                  tt-prog-ponto.conteudo = b1-item.cod-unid-neg) 
                THEN ASSIGN int-estrutura.garantia = 0
                            int-estrutura.venda    = NO.

            END.

            FIND FIRST tt-int-estrutura 
                 WHERE tt-int-estrutura.es-codigo = int-estrutura.es-codigo NO-ERROR.

            IF l-estrutura THEN
                RUN pi-update-estrutura(int-estrutura.es-codigo).
        END.

    END.
    ELSE DO:
        find first int-estrutura EXCLUSIVE-LOCK
             where int-estrutura.it-codigo = b-old-estrutura.it-codigo
               and int-estrutura.es-codigo = b-old-estrutura.es-codigo
               and int-estrutura.sequencia = b-old-estrutura.sequencia no-error.
        
        if not avail int-estrutura then do:          
            create int-estrutura.
            assign int-estrutura.it-codigo = b-old-estrutura.it-codigo
                   int-estrutura.es-codigo = b-old-estrutura.es-codigo
                   int-estrutura.sequencia = b-old-estrutura.sequencia.

            FIND FIRST b1-item WHERE
                       b1-item.it-codigo = b-old-estrutura.it-codigo
                       NO-LOCK NO-ERROR.

            IF AVAIL b1-item 
            THEN DO:

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "win111":U,
                                   INPUT 3,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).

                IF CAN-FIND(FIRST tt-prog-ponto WHERE
                                  tt-prog-ponto.conteudo = b1-item.cod-unid-neg) 
                THEN ASSIGN int-estrutura.garantia = 0
                            int-estrutura.venda    = NO.

            END.
        END.

        ASSIGN int-estrutura.it-codigo = b-estrutura.it-codigo
               int-estrutura.es-codigo = b-estrutura.es-codigo
               int-estrutura.sequencia = b-estrutura.sequencia.

    END.

    ASSIGN int-estrutura.visivel = YES.

END.



PROCEDURE pi-trata-int-local-montag:

    IF AVAIL b-estrutura THEN DO:

        FOR EACH int-local-montag EXCLUSIVE-LOCK
            WHERE int-local-montag.it-codigo = b-estrutura.it-codigo
            AND   int-local-montag.sequencia = b-estrutura.sequencia
            AND   int-local-montag.es-codigo = b-estrutura.es-codigo:

            DELETE int-local-montag.

        END.

        RUN pi-carrega-tts.

        FOR EACH tt-pos
            WHERE tt-pos.letra <> "":

            CREATE int-local-montag.
            ASSIGN int-local-montag.it-codigo    = b-estrutura.it-codigo
                   int-local-montag.sequencia    = b-estrutura.sequencia
                   int-local-montag.es-codigo    = b-estrutura.es-codigo
                   int-local-montag.local-montag = tt-pos.letra + tt-pos.pos
                   int-local-montag.letra        = tt-pos.letra
                   int-local-montag.numero       = tt-pos.pos.
        END.
    END.
END PROCEDURE.



PROCEDURE pi-carrega-tts:

    DEFINE VARIABLE l-erro AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cLocalMontagem AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-local   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-letra   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-parte   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-ind     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-parte1  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pos-ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pos-fim AS CHARACTER   NO-UNDO.
    
    
    ASSIGN cLocalMontagem = b-estrutura.local-montag
           cLocalMontagem = REPLACE(cLocalMontagem,"),",");")
           cLocalMontagem = REPLACE(cLocalMontagem,") ,",");")
           cLocalMontagem = REPLACE(cLocalMontagem," ","").

    EMPTY TEMP-TABLE tt-pos.
    
    IF INDEX(cLocalMontagem /*estrutura.local-montag*/ ,";") = 0 AND 
       INDEX(cLocalMontagem /*estrutura.local-montag*/ ,"(") = 0 THEN DO:

        RUN piCriaSegmento(INPUT cLocalMontagem /*estrutura.local-montag*/ ,
                           INPUT "",
                           INPUT "", 
                           INPUT YES).
    END.
    ELSE DO i = 1 TO NUM-ENTRIES(cLocalMontagem /*estrutura.local-montag*/ ,";"):

        ASSIGN c-local = ENTRY(i,cLocalMontagem /*estrutura.local-montag*/ ,";").
        IF INDEX(c-local,"(") = 0 THEN DO:

            ASSIGN c-letra = c-local
                   c-parte = "".
            RUN piCriaSegmento(INPUT c-letra,
                               INPUT "",
                               INPUT "",
                               INPUT yes).

        END.
        ELSE DO:

            ASSIGN c-letra = substr(c-local,1,index(c-local,"(") - 1)
                    c-parte = substr(c-local,
                                     index(c-local,"(") + 1, 
                                     index(c-local,")") - (index(c-local,"(") + 1)).

            DO i-ind = 1 TO NUM-ENTRIES(c-parte,","):

                ASSIGN c-parte1 = ENTRY(i-ind,c-parte,",") NO-ERROR.
                IF index(c-parte1,"-") <> 0 THEN DO:

                    ASSIGN c-pos-ini = ENTRY(1,c-parte1,"-")
                           c-pos-fim = ENTRY(2,c-parte1,"-").

                    IF ASC(CAPS(c-pos-ini)) >= 65 THEN DO:
                        RUN piCriaSegmento(INPUT c-letra, 
                                           INPUT c-pos-ini, 
                                           INPUT c-pos-fim, 
                                           INPUT YES).
                    END.
                    ELSE DO:
                        RUN piCriaSegmento(INPUT c-letra, 
                                           INPUT c-pos-ini, 
                                           INPUT c-pos-fim, 
                                           INPUT NO).
                    END.
                END.
                ELSE DO:
                    RUN piCriaSegmento(INPUT c-letra, 
                                       INPUT c-parte1, 
                                       INPUT c-parte1, 
                                       INPUT YES).
                END.
            END.
        END.
    END. /* ELSE DO i = 1 TO NUM-ENTRIES(estrutura.local-montag,";"): */   

END PROCEDURE.


PROCEDURE piCriaSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-letra as char no-undo.
   def input param c-ini   as char no-undo.
   def input param c-fim   as char no-undo.
   def input param l-alfa  as logical no-undo.
   def var c-carac as char    no-undo.
   def var i       as integer no-undo.
   def var ini     as int     no-undo.
   def var fim     as int     no-undo.
   
   if l-alfa = no then do:
      assign ini = int(c-ini)
             fim = int(c-fim).
      do i = ini to fim:
         assign c-carac  = caps(string(i)).
         FOR first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-carac):
         END.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = trim(c-carac). 
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-carac), output tt-pos.ord).       
         end.          
      end.
   end.
   else do:
      if c-ini = c-fim then do:
         FOR first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-ini):
         END.
                           
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = caps(trim(c-ini)).
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-ini), output tt-pos.ord).
         end.
      end.   
      else do:
         do i = asc(caps(c-ini)) to asc(caps(c-fim)):
            FOR first tt-pos where tt-pos.letra = c-letra
                                and tt-pos.pos   = chr(i):
            END.
                              
            if not avail tt-pos then do:                  
               create tt-pos.
               assign tt-pos.letra   = caps(c-letra)
                      tt-pos.pos     = chr(i).
               if trim(tt-pos.pos) = "0" then 
                  assign tt-pos.pos = "".
               run PiConverte(chr(i), output tt-pos.ord).
            end.
         end.
      end.          
   end.
END PROCEDURE.


PROCEDURE piConverte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-pos as char no-undo.
   def output param de-num as dec no-undo.

   def var c-carac as char    no-undo.
   def var c-mult  as char    no-undo.
   def var i-cont  as integer no-undo.
   def var l-alfa  as logical no-undo.
   
   def var de-mult as decimal no-undo.

   assign c-mult = "100000000000000000000000000000".
   do i-cont = 1 to length(trim(c-pos)):
      assign c-carac = c-carac 
                     + string(asc(caps(substring(c-pos,i-cont,1)))).
      if asc(caps(substring(c-pos,i-cont,1))) >= 65 then do: 
         l-alfa = yes.
      end.
   end.
   if l-alfa then do:
      assign de-mult = dec(substring(c-mult,1,((30 - length(c-carac)) + 1)))
             de-num = (dec(c-carac) * de-mult).
   end.
   else 
      assign de-num = dec(c-pos).

END PROCEDURE.


PROCEDURE pi-estrutura:

    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.
    
    FOR EACH estrutura no-lock 
       WHERE estrutura.it-codigo = p-it-codigo:

       FIND FIRST item no-lock
             WHERE item.it-codigo = estrutura.es-codigo NO-ERROR.

       ASSIGN i-nivel = i-nivel + 1.
       
       FIND FIRST b-int-estrutura-aux NO-LOCK
            WHERE b-int-estrutura-aux.it-codigo = estrutura.it-codigo
              AND b-int-estrutura-aux.es-codigo = estrutura.es-codigo
              AND b-int-estrutura-aux.sequencia = estrutura.sequencia NO-ERROR.
        
       IF  AVAIL b-int-estrutura-aux THEN DO:
           FIND tt-int-estrutura EXCLUSIVE-LOCK
                WHERE tt-int-estrutura.es-codigo = b-int-estrutura-aux.es-codigo NO-ERROR.

            IF  NOT AVAIL tt-int-estrutura THEN DO:
               
                CREATE tt-int-estrutura.
                ASSIGN tt-int-estrutura.es-codigo    = estrutura.es-codigo
                       tt-int-estrutura.fim-validade = estrutura.data-termino
                       tt-int-estrutura.garantia     = b-int-estrutura-aux.garantia 
                       tt-int-estrutura.venda        = b-int-estrutura-aux.venda
                       tt-int-estrutura.r-rowid      = ROWID(b-int-estrutura-aux).

            END.
            /* sobrepor se tiver data de validade maior*/
            ELSE 
                IF estrutura.data-termino > tt-int-estrutura.fim-validade
                AND tt-int-estrutura.r-rowid <> rowid(b-int-estrutura-aux) 
                THEN DO:
                    ASSIGN tt-int-estrutura.fim-validade = estrutura.data-termino
                           tt-int-estrutura.garantia     = b-int-estrutura-aux.garantia 
                           tt-int-estrutura.venda        = b-int-estrutura-aux.venda.

                END.
       END.

       FIND FIRST b-e NO-LOCK
           WHERE b-e.it-codigo = estrutura.es-codigo NO-ERROR.
       
       IF l-estrutura THEN
           RUN pi-estrutura(INPUT estrutura.es-codigo).

       ASSIGN i-nivel = i-nivel - 1.
   end.
END.

PROCEDURE pi-update-estrutura:

    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.
    
    FOR EACH estrutura no-lock 
       WHERE estrutura.it-codigo = p-it-codigo:

       FIND FIRST item no-lock
             WHERE item.it-codigo = estrutura.es-codigo NO-ERROR.

       ASSIGN i-nivel = i-nivel + 1.
       
       FIND FIRST b-int-estrutura-aux EXCLUSIVE-LOCK
            WHERE b-int-estrutura-aux.it-codigo = estrutura.it-codigo
              AND b-int-estrutura-aux.es-codigo = estrutura.es-codigo
              AND b-int-estrutura-aux.sequencia = estrutura.sequencia NO-ERROR.
        
       IF  AVAIL b-int-estrutura-aux THEN DO:
           FIND FIRST tt-int-estrutura NO-LOCK
                WHERE tt-int-estrutura.es-codigo = b-int-estrutura-aux.es-codigo 
                  AND tt-int-estrutura.r-rowid   <> ROWID(b-int-estrutura-aux) NO-ERROR.

            IF  AVAIL tt-int-estrutura 
            THEN DO:
                ASSIGN b-int-estrutura-aux.garantia = tt-int-estrutura.garantia   
                       b-int-estrutura-aux.venda    = tt-int-estrutura.venda. 
            END.  
       END.

       FIND FIRST b-e NO-LOCK
           WHERE b-e.it-codigo = estrutura.es-codigo NO-ERROR.
       
       IF l-estrutura THEN
           RUN pi-update-estrutura(INPUT estrutura.es-codigo).

       ASSIGN i-nivel = i-nivel - 1.
   end.
END.

