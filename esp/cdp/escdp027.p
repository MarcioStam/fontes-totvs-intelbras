/********************************************************************************
** Copyright Intelbras S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: esp/cdp/escd024.p
**  Objetivo: Validar CGC/CPF 
**  Autor...: SqlWorks    
**  Data....: 19.05.2008 16:11
*******************************************************************************/

{esp/crm/escrm001.i1}

def input  param p-cgc-cpf  as character no-undo.
def input  param p-natureza as integer   no-undo.
DEF OUTPUT PARAM TABLE FOR tt-erros-geral.

def var c-cgc       as character format "x(20)" no-undo.
def var c-cgc-aux   as character format "x(20)" no-undo.
def var c-dig-cgc   as character                no-undo.
def var i-multiplic as integer                  no-undo.
def var i-cont      as integer                  no-undo.
def var i-digit-1   as integer format 9         no-undo.
def var i-digit-2   as integer format 9         no-undo.
def var i-digito    as integer format 99        no-undo.
def var de-result   as decimal                  no-undo.
def var de-soma     as decimal                  no-undo.

EMPTY TEMP-TABLE tt-erros-geral.

find first param-global no-lock no-error.
if  avail param-global 
then do:

    /*---- Pessoa F­sica ----*/
    if  p-natureza = 1 
    then do:
        if  param-global.bloqueio-cgc <> 1 
        then do:
          RUN pi-calcula-cpf.
        end.
    end.

    /*---- Pessoa Juridica ----*/
    if  p-natureza = 2 then do:
        if  param-global.id-federal-obrigatorio = yes then do:
            if  p-cgc-cpf = " " then do:
                {utp/ut-liter.i CPF}
                run utp/ut-msgs.p (input "msg",
                                   input 15369,
                                   input trim(return-value)).
                
                IF RETURN-VALUE <> ""
                THEN DO:
                    RUN pi-cria-erro (INPUT 15369,
                                      INPUT RETURN-VALUE). 

                    return 'NOK'.
                END.
            end.
        end.

        if  param-global.bloqueio-cgc <> 1 then do:
            
            RUN pi-calcula-cgc.

        end.

    end.

end.

PROCEDURE pi-calcula-cpf:
/* - Rotina para validar CPF - (Pessoa F­sica). */

assign c-cgc     = ""
       c-cgc-aux = "".

do  i-cont = 1 to length(p-cgc-cpf):
    if  can-do("0,1,2,3,4,5,6,7,8,9",substr(p-cgc-cpf,i-cont,1)) then do:
        assign c-cgc = c-cgc + substr(p-cgc-cpf,i-cont,1).
    end.
    else do:
        if  substring(p-cgc-cpf,i-cont,1) <> "."
        and substring(p-cgc-cpf,i-cont,1) <> "/"
        and substring(p-cgc-cpf,i-cont,1) <> "-"
        and substring(p-cgc-cpf,i-cont,1) <> " " then do:
            /* CPF possui caracteres invalidos */
            run utp/ut-msgs.p (input "msg",
                               input 1009,
                               input "").

            RUN pi-cria-erro (INPUT 1009,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
        end.
   end.
end.

if  param-global.bloqueio-cgc = 3 then do:
    if  dec(c-cgc) = 0 then do:
        /* CPF deve conter digitos numericos */
        run utp/ut-msgs.p (input "msg",
                           input 972,
                           input "").

        RUN pi-cria-erro (INPUT 972,
                          INPUT RETURN-VALUE). 
        return 'NOK'.
    end.
end.
else do:
    if  param-global.bloqueio-cgc = 2 then do:
        if  dec(c-cgc) = 0 then do:
            /* CPF deve conter digitos numericos, Confirma? */
            run utp/ut-msgs.p (input "msg",
                               input 15276,
                               input "").

            RUN pi-cria-erro (INPUT 15276,
                             INPUT RETURN-VALUE). 
            
            return 'NOK'.
        end.
    end.
end.

assign c-cgc       = fill("0",20 - length(c-cgc)) + c-cgc
       c-cgc       = "00" + substr(c-cgc,1,18)
       i-multiplic = 1.

do  i-cont = 1 to 18:
    assign i-multiplic = i-multiplic + 1
           de-result   = dec(substr(c-cgc,21 - i-cont ,1)) * i-multiplic
           de-soma     = de-soma + de-result.
end.

assign i-digit-1 = de-soma - (truncate(de-soma / 11,0) * 11)
       i-digit-1   = if   i-digit-1 < 2 then 0
                     else 11 - (de-soma - (truncate(de-soma / 11,0) * 11))
       c-cgc       = string(dec(c-cgc),"9999999999999999999")
                   + string(i-digit-1)
       de-soma     = 0
       de-result   = 0
       i-multiplic = 1.

do  i-cont = 1 to 19:
    assign i-multiplic = i-multiplic + 1
           de-result   = dec(substr(c-cgc,21 - i-cont,1)) * i-multiplic
           de-soma     = de-soma + de-result.
end.

assign i-digit-2   = 11 - (de-soma - (truncate(de-soma / 11,0) * 11))
       i-digit-2   = if  i-digit-2 > 9 then 0
                     else i-digit-2
       i-digito    = i-digit-1 * 10 + i-digit-2
       de-soma     = 0.

/* este processo e feito para retirar os espacos em branco que ficam na
   variavel p-cgc-cpf quando o cgc/cpf for digitado com o caracter "-" */

do  i-cont = 1 to 20:
    if  substr(p-cgc-cpf,i-cont,1) <> " " then
        c-cgc-aux = c-cgc-aux + substr(p-cgc-cpf,i-cont,1).
end.

assign p-cgc-cpf = c-cgc-aux
       p-cgc-cpf = fill("0",20 - length(p-cgc-cpf)) + p-cgc-cpf.
/* */

if  string(i-digito,"99") <> substr(p-cgc-cpf,19,2) then do:
    if  param-global.bloqueio-cgc = 2 then do:
        /* Digito verificador nao confere. Confirma CPF? */
        run utp/ut-msgs.p (input "msg",
                           input 1008,
                           input "").

        RUN pi-cria-erro (INPUT 1008,
                          INPUT RETURN-VALUE). 
        
        return 'NOK'.
    end.
    else do:
        if  param-global.bloqueio-cgc = 3 then do:
            /* Digito Verificador do CPF nao confere */
            run utp/ut-msgs.p (input "msg",
                               input 1007,
                               input "").
            
            RUN pi-cria-erro (INPUT 1007,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
        end.
    end.
end.

END PROCEDURE.


PROCEDURE pi-calcula-cgc:
 /* Rotina para Calculo do CGC - (Pessoa Juridica). */

assign c-cgc = "".

do  i-cont = 1 to 18:
    if  can-do("0,1,2,3,4,5,6,7,8,9",substr(p-cgc-cpf,i-cont,1)) then do:
        assign c-cgc = c-cgc + substr(p-cgc-cpf,i-cont,1).
    end.
    else do:
        if  substring(p-cgc-cpf,i-cont,1) <> "."
        and substring(p-cgc-cpf,i-cont,1) <> "/"
        and substring(p-cgc-cpf,i-cont,1) <> "-"
        and substring(p-cgc-cpf,i-cont,1) <> " " then do:
            /* CGC possui caracteres invalidos */
            run utp/ut-msgs.p (input "msg",
                               input 1009,
                               input "").

            RUN pi-cria-erro (INPUT 1009,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
        end.
    end.
end.

if  param-global.bloqueio-cgc = 3 then do:
    if  dec(c-cgc) = 0 then do:
        /* CPF deve conter digitos numericos */
        run utp/ut-msgs.p (input "msg",
                           input 972,
                           input "").

        RUN pi-cria-erro (INPUT 972,
                          INPUT RETURN-VALUE). 

        return 'NOK'.
    end.
end.
else do:
    if  param-global.bloqueio-cgc = 2 then do:
        if  dec(c-cgc) = 0 then do:
            /* CPF deve conter digitos numericos, Confirma? */
            run utp/ut-msgs.p (input "msg",
                               input 15923,
                               input "").

            RUN pi-cria-erro (INPUT 15923,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
            
        end.
    end.
end.

if  param-global.bloqueio-cgc = 3 then do:
    if  dec(substr(c-cgc,9,4)) = 0 then do:
        /* Filial n’o pode ser zero */
        run utp/ut-msgs.p (input "msg",
                           input 29286,
                           input "").

        RUN pi-cria-erro (INPUT 29286,
                          INPUT RETURN-VALUE). 

        return 'NOK'.
    end.
end.
else do:
    if  param-global.bloqueio-cgc = 2 then do:
        if  dec(substr(c-cgc,9,4)) = 0 then do:
            /* Filial n’o pode ser zero, Confirma? */
            run utp/ut-msgs.p (input "msg",
                               input 29287,
                               input "").

            RUN pi-cria-erro (INPUT 29287,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
        end.
    end.
end.

assign c-cgc     = fill("0",20 - length(c-cgc)) + c-cgc
       c-dig-cgc = substring(c-cgc,19,2)
       c-cgc     = "00" + substr(c-cgc,1,18).

assign i-multiplic = 1.

do  i-cont = 1 to 18:
    assign i-multiplic = i-multiplic + 1.
    if  i-multiplic > 9 then i-multiplic = 2.
    assign de-result = dec(substr(c-cgc,21 - i-cont ,1)) * i-multiplic
           de-soma   = de-soma + de-result.
end.

assign i-digit-1 = de-soma - (truncate(de-soma / 11,0) * 11)
       i-digit-1   = if   i-digit-1 < 2 then 0
                     else 11 - (de-soma - (truncate(de-soma / 11,0) * 11))
       c-cgc       = string(dec(c-cgc),"9999999999999999999")
                   + string(i-digit-1)
       de-soma     = 0
       de-result   = 0
       i-multiplic = 1.

do  i-cont = 1 to 19:
    assign i-multiplic = i-multiplic + 1.
    if  i-multiplic > 9 then i-multiplic = 2.
    assign de-result = dec(substr(c-cgc,21 - i-cont,1)) * i-multiplic
           de-soma   = de-soma + de-result.
end.

assign i-digit-2   = 11 - (de-soma - (truncate(de-soma / 11,0) * 11))
       i-digit-2   = if  i-digit-2 > 9 then 0
                     else i-digit-2
       i-digito    = i-digit-1 * 10 + i-digit-2
       de-soma     = 0
       p-cgc-cpf    = fill("0",20 - length(p-cgc-cpf)) + p-cgc-cpf.

if  string(i-digito,"99") <> c-dig-cgc then do:
    if  param-global.bloqueio-cgc = 2 then do:
        /* Digito verificador nao confere. Confirma CPF? */
        run utp/ut-msgs.p (input "msg",
                           input 1008,
                           input "").

        RUN pi-cria-erro (INPUT 1008,
                          INPUT RETURN-VALUE). 

        return 'NOK'.
        
    end.
    else do:
        if  param-global.bloqueio-cgc = 3 then do:
            /* Digito Verificador do CPF nao confere */
            run utp/ut-msgs.p (input "msg",
                               input 1007,
                               input "").

            RUN pi-cria-erro (INPUT 1007,
                              INPUT RETURN-VALUE). 

            return 'NOK'.
        end.
    end.
end.

END PROCEDURE.

PROCEDURE pi-cria-erro:
DEFINE INPUT PARAMETER p-num-erro  AS INTEGER.
DEFINE INPUT PARAMETER p-des-erro  AS CHARACTER.
  
  create tt-erros-geral.
  assign tt-erros-geral.cod-erro   = p-num-erro
         tt-erros-geral.des-erro   = p-des-erro.

  FIND FIRST cadast_msg NO-LOCK WHERE
             cadast_msg.cdn_msg = p-num-erro NO-ERROR.
  IF AVAIL cadast_msg THEN
     ASSIGN tt-erros-geral.identif-msg = string(cadast_msg.idi_tip_msg).
  ELSE 
     ASSIGN tt-erros-geral.identif-msg = "1".

END PROCEDURE.


