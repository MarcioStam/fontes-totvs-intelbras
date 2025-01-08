/*****************************************************************************
**
**   Programa:  es0669.p
**
**   Funcao:  Cria os reg da tab controle ORACLE
**
**   Data:  09/08/2001
**
**   Autor:  Claudiney Klitzke  - INTELBRAS S/A.
**
******************************************************************************/

/********** INCLUDES PADROES         ***************************************/   

/********** DEFINICAO DE VARIAVEIS   ****************************************/
                            
def input parameter l-tipo      as log.
def input parameter c-tabela    as char format "X(30)".
def input parameter c-chave1    as char format "X(30)".
def input parameter c-chave2    as char format "X(30)".
def input parameter c-chave3    as char format "X(30)".
def input parameter c-chave4    as char format "X(30)".
def input parameter c-chave5    as char format "X(30)".
def input parameter c-chave6    as char format "X(30)".
def input parameter c-chave7    as char format "X(30)".
def input parameter c-chave8    as char format "X(30)".
def input parameter c-chave9    as char format "X(30)".

/** GAMBI **/
if c-tabela <> 'item' then leave.

/********** DEFINICAO DE STREAMS     ****************************************/
/********** DEFINICAO DE TEMP-TABLES ****************************************/
def buffer b-controle-oracle for controle-oracle.

/********** DEFINICAO DE BUFFERS     ****************************************/
/********** DEFINICAO DE QUERYS      ****************************************/
/********** DEFINICAO DE BROWSES     ****************************************/
/********** DEFINICAO DE FORMS       ****************************************/
/********** ON ENTRY                 ****************************************/
/********** ON LEAVE                 ****************************************/
/********** ON RETURN                ****************************************/
/********** ON ANY-KEY               ****************************************/
/********** ON VALUE-CHANGED         ****************************************/
/********** ON ROW-ENTRY             ****************************************/
/********** ON GO (F1)               ****************************************/
/********** ON END-ERROR (F4)        ****************************************/
/********** ON GET (F5)              ****************************************/
/********** ON PUT (F6)              ****************************************/
/********** ON RECALL (F7)           ****************************************/
/********** ON CLEAR (F8)            ****************************************/

/********** CORPO DO PROGRAMA        ***************************************/  

    FIND FIRST controle-oracle
     where controle-oracle.tabela     = c-tabela 
       and controle-oracle.chave-01   = c-chave1
       and controle-oracle.chave-02   = c-chave2
       and controle-oracle.chave-03   = c-chave3
       and controle-oracle.chave-04   = c-chave4
       and controle-oracle.chave-05   = c-chave5
       and controle-oracle.chave-06   = c-chave6
       and controle-oracle.chave-07   = c-chave7
       and controle-oracle.chave-08   = c-chave8
       and controle-oracle.chave-09   = c-chave9 EXCLUSIVE-LOCK NO-ERROR.
    
if not avail controle-oracle then do:
   create controle-oracle.
   assign controle-oracle.tabela     = c-tabela
          controle-oracle.chave-01   = c-chave1
          controle-oracle.chave-02   = c-chave2
          controle-oracle.chave-03   = c-chave3
          controle-oracle.chave-04   = c-chave4
          controle-oracle.chave-05   = c-chave5
          controle-oracle.chave-06   = c-chave6
          controle-oracle.chave-07   = c-chave7
          controle-oracle.chave-08   = c-chave8
          controle-oracle.chave-09   = c-chave9
          controle-oracle.tipo       = l-tipo.
end. 
else do:
   if controle-oracle.tipo <> l-tipo then do:                        
      assign controle-oracle.tipo = l-tipo.
   end.
end.                          

find current controle-oracle NO-LOCK no-error.

/********** PROCEDURES               ***************************************/   

/* es0669.p  <EOF>*/
    
