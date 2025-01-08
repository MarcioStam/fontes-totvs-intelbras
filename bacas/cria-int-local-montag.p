
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

DEFINE STREAM st-mudanca.

DEFINE VARIABLE i-numero AS INTEGER     NO-UNDO.

/*OUTPUT TO c:\temp\int-local-montag-inconsistenciasNew.csv.*/
OUTPUT TO /opt/totvs/spool/int-local-montag-inconsistenciasNew.csv.

FOR EACH ITEM NO-LOCK
    WHERE /*ITEM.it-codigo = "1940151"
    AND*/   ITEM.cod-obsoleto = 1:

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = ITEM.it-codigo
        AND   estrutura.local-montag <> "":
    
        EMPTY TEMP-TABLE tt-pos.

        RUN pi-trata-local-simples.
        
        RUN pi-carrega-tts.
    
        IF RETURN-VALUE = "OK":U THEN DO:
        
            FOR EACH tt-pos
            	WHERE tt-pos.letra <> "":
        
                /*ASSIGN i-numero = int(tt-pos.pos) NO-ERROR.*/

                IF NOT CAN-FIND(FIRST int-local-montag
                                WHERE int-local-montag.it-codigo = estrutura.it-codigo
                                AND   int-local-montag.sequencia = estrutura.sequencia
                                AND   int-local-montag.es-codigo = estrutura.es-codigo
                                AND   int-local-montag.local-montag = tt-pos.letra + tt-pos.pos)  THEN DO:
                
                	CREATE int-local-montag.
                	ASSIGN int-local-montag.it-codigo    = estrutura.it-codigo
                		   int-local-montag.sequencia    = estrutura.sequencia
                		   int-local-montag.es-codigo    = estrutura.es-codigo
                		   int-local-montag.local-montag = tt-pos.letra + tt-pos.pos
                		   int-local-montag.letra        = tt-pos.letra
                           int-local-montag.numero       = tt-pos.pos.

                END.
            
            END.
    
        END.
    
    END.

END.

OUTPUT CLOSE.
     

PROCEDURE pi-carrega-tts:

    DEFINE VARIABLE l-erro          AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cLocalMontagem  AS CHARACTER    NO-UNDO.
    
    DEFINE VARIABLE i               AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-local         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-letra         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-parte         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE i-ind           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-parte1        AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-pos-ini       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-pos-fim       AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE i-cont-ini      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont-fim      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-verifica      AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-validas       AS CHARACTER   NO-UNDO.
    
    
    ASSIGN cLocalMontagem = estrutura.local-montag
           cLocalMontagem = REPLACE(cLocalMontagem,"),",");")
           cLocalMontagem = REPLACE(cLocalMontagem,") ,",");")
           cLocalMontagem = REPLACE(cLocalMontagem," ","").

    ASSIGN c-validas = "1234567890-,".

    EMPTY TEMP-TABLE tt-pos.

    IF INDEX(cLocalMontagem /*estrutura.local-montag*/ ,"(") =  0 OR 
       INDEX(cLocalMontagem /*estrutura.local-montag*/ ,"=") <> 0 THEN DO:

        PUT UNFORMATTED
            estrutura.it-codigo         + ";" + 
            string(estrutura.sequencia) + ";" + 
            estrutura.es-codigo         + ";" + 
            estrutura.local-montag      SKIP.

        RETURN "NOK":U.

    END.


    ASSIGN i-cont-ini = 0
           i-cont-fim = 0.
    
    DO i = 1 TO LENGTH(cLocalMontagem):

        IF SUBSTRING(cLocalMontagem,i,1) = "(" THEN
            ASSIGN i-cont-ini = i-cont-ini + 1.

        IF SUBSTRING(cLocalMontagem,i,1) = ")" THEN
            ASSIGN i-cont-fim = i-cont-fim + 1.

    END.

    IF i-cont-ini <> i-cont-fim OR i-cont-ini = 0 OR i-cont-fim = 0 THEN DO:

        PUT UNFORMATTED
            estrutura.it-codigo         + ";" + 
            string(estrutura.sequencia) + ";" + 
            estrutura.es-codigo         + ";" + 
            estrutura.local-montag      SKIP.

        RETURN "NOK":U.

    END.


    IF INDEX(cLocalMontagem /*estrutura.local-montag*/ ,"(") = 0 AND
       INDEX(cLocalMontagem /*estrutura.local-montag*/ ,";") = 0 THEN DO:

        RUN piCriaSegmento(INPUT cLocalMontagem /*estrutura.local-montag*/ ,
                           INPUT "",
                           INPUT "", 
                           INPUT YES).

    END.
    ELSE DO i = 1 TO NUM-ENTRIES(cLocalMontagem /*estrutura.local-montag*/ ,";"):

        ASSIGN c-local = ENTRY(i,cLocalMontagem /*estrutura.local-montag*/ ,";").

        /**/

        ASSIGN i-cont-ini = 0
               i-cont-fim = 0.
        
        DO i-ind = 1 TO LENGTH(c-local):
    
            IF SUBSTRING(c-local,i-ind,1) = "(" THEN
                ASSIGN i-cont-ini = i-cont-ini + 1.
    
            IF SUBSTRING(c-local,i-ind,1) = ")" THEN
                ASSIGN i-cont-fim = i-cont-fim + 1.
    
        END.
    
        IF i-cont-ini <> i-cont-fim OR i-cont-ini = 0 OR i-cont-fim = 0 THEN DO:
    
            PUT UNFORMATTED
                estrutura.it-codigo         + ";" + 
                string(estrutura.sequencia) + ";" + 
                estrutura.es-codigo         + ";" + 
                estrutura.local-montag      SKIP.
    
            RETURN "NOK":U.
    
        END.

        /**/

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

            DO i-ind = 1 TO LENGTH(c-parte):

                IF INDEX(c-validas, SUBSTRING(c-parte, i-ind, 1)) = 0 THEN DO:
            
                    PUT UNFORMATTED
                        estrutura.it-codigo         + ";" + 
                        string(estrutura.sequencia) + ";" + 
                        estrutura.es-codigo         + ";" + 
                        estrutura.local-montag      SKIP.
            
                    RETURN "NOK":U.
            
                END.
            
            END.

            DO i-ind = 1 TO NUM-ENTRIES(c-parte,","):

                ASSIGN c-parte1 = ENTRY(i-ind,c-parte,",") NO-ERROR.

                
                IF INDEX(c-parte1, ".") <> 0 THEN DO:

                    PUT UNFORMATTED
                        estrutura.it-codigo         + ";" + 
                        string(estrutura.sequencia) + ";" + 
                        estrutura.es-codigo         + ";" + 
                        estrutura.local-montag      SKIP.
            
                    RETURN "NOK":U.

                END.

                IF index(c-parte1,"-") <> 0 THEN DO:

                    ASSIGN c-pos-ini = ENTRY(1,c-parte1,"-")
                           c-pos-fim = ENTRY(2,c-parte1,"-").

                    ASSIGN i-verifica = INT(c-pos-ini) + INT(c-pos-fim) NO-ERROR.

                    IF ERROR-STATUS:ERROR THEN DO:

                        PUT UNFORMATTED
                            estrutura.it-codigo         + ";" + 
                            string(estrutura.sequencia) + ";" + 
                            estrutura.es-codigo         + ";" + 
                            estrutura.local-montag      SKIP.
                
                        RETURN "NOK":U.

                    END.

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

    RETURN "OK":U.

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
			

PROCEDURE pi-trata-local-simples:

    DEFINE VARIABLE i-aux AS INTEGER    NO-UNDO.
    DEFINE VARIABLE l- AS LOGICAL       NO-UNDO.
    DEFINE VARIABLE c-parte-char    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-parte-num     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-num AS LOGICAL     NO-UNDO.


    IF AVAIL estrutura THEN DO:

        IF INDEX(estrutura.local-montag, "(") <> 0 OR
           INDEX(estrutura.local-montag, ")") <> 0 OR
           INDEX(estrutura.local-montag, ",") <> 0 OR
           INDEX(estrutura.local-montag, ";") <> 0 OR
           INDEX(estrutura.local-montag, ";") <> 0 THEN
            RETURN.

        ASSIGN l-num = FALSE
               c-parte-char = ""
               c-parte-num  = "".

        DO i-aux = 1 TO LENGTH(estrutura.local-montag):

            IF (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 48 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <=  57) OR   /* N£mero */
               (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 65 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <=  90) OR   /* Letras Maiusculas */
               (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 97 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <= 122)      /* Letras Minusculas */
                THEN DO:

                /* Letra */
                IF (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 65 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <=  90) OR 
                   (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 97 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <= 122) THEN DO:

                    IF l-num = TRUE THEN
                        RETURN.

                    ASSIGN c-parte-char = c-parte-char + SUBSTRING(estrutura.local-montag, i-aux, 1).

                END.


                /* N£mero */
                IF (ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) >= 48 AND ASC(SUBSTRING(estrutura.local-montag,i-aux,1)) <=  57) THEN DO:

                    ASSIGN l-num = TRUE.

                    ASSIGN c-parte-num = c-parte-num + SUBSTRING(estrutura.local-montag, i-aux, 1).

                END.



            END.
            ELSE DO:

                RETURN.

            END.

        END.

        IF c-parte-char <> "" AND
           c-parte-num  <> "" THEN DO:

            FIND CURRENT estrutura EXCLUSIVE-LOCK.

            /*OUTPUT STREAM st-mudanca TO c:\temp\mudan‡a.csv APPEND.*/
            OUTPUT STREAM st-mudanca TO /opt/totvs/spool/mudanca.csv APPEND.

            PUT STREAM st-mudanca UNFORMATTED 
                estrutura.local-montag + ";" + c-parte-char + "(" + c-parte-num + ")" SKIP.
            OUTPUT STREAM st-mudanca CLOSE.
    
            ASSIGN estrutura.local-montag = c-parte-char + "(" + c-parte-num + ")".
    
            FIND CURRENT estrutura NO-LOCK.
    
        END.

    END.

END PROCEDURE.
