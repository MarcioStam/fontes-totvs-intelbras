{esp/esb/out/msg0111.i} 
    

def INPUT  param  p-classificacao          AS CHAR.
def INPUT  param  p-categoria              AS CHAR.             
def INPUT  param  p-tipo-param-global      AS INTEGER.
def INPUT  param  p-CodigoUnidadeNegocio   AS CHAR.
DEF OUTPUT PARAM TABLE FOR resultado.
DEF OUTPUT PARAM TABLE FOR msg0111r-ParametroGlobal.


DEF TEMP-TABLE msg0111-aux LIKE msg0111 
    FIELD valor AS CHAR.

DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".
INPUT FROM "c:\intelbras\canais\faturamento\beneficios.csv".
    
DEF VAR i AS INTEGER NO-UNDO.

REPEAT: 

    IMPORT UNFORMATTED c-linha.
    IF  i <> 0 THEN DO:
    
        FIND FIRST  msg0111-aux
            WHERE  msg0111-aux.CodigoClassificacao  = entry(3, c-linha, ";")
              AND  msg0111-aux.CodigoCategoria      = entry(4, c-linha, ";")
              AND  msg0111-aux.TipoParametroGlobal  = int(entry(6, c-linha, ";"))
              AND  msg0111-aux.CodigoUnidadeNegocio = entry(2, c-linha, ";") NO-ERROR.

        IF  NOT AVAIL   msg0111-aux THEN DO:
            
            CREATE  msg0111-aux.
            ASSIGN  msg0111-aux.CodigoClassificacao  = entry(3, c-linha, ";")
                    msg0111-aux.CodigoCompromisso    = ?
                    msg0111-aux.CodigoCategoria      = entry(4, c-linha, ";")
                    msg0111-aux.CodigoBeneficio      = ?
                    msg0111-aux.TipoParametroGlobal  = int(entry(6, c-linha, ";"))
                    msg0111-aux.CodigoNivelPosVenda  = ?
                    msg0111-aux.CodigoUnidadeNegocio = entry(2, c-linha, ";").
        END.

        ASSIGN  msg0111-aux.valor =  entry(7, c-linha, ";").

    END.


    i = i + 1.

    IF  c-linha = "" THEN
        LEAVE.
END.

INPUT CLOSE.

CREATE resultado.

FIND FIRST  msg0111-aux
    WHERE  msg0111-aux.CodigoClassificacao  = p-classificacao
      AND  msg0111-aux.CodigoCategoria      = p-categoria
      AND  msg0111-aux.TipoParametroGlobal  = p-tipo-param-global
      AND  msg0111-aux.CodigoUnidadeNegocio = p-CodigoUnidadeNegocio NO-ERROR.



IF  AVAIL msg0111-aux THEN DO:

    CREATE msg0111r-ParametroGlobal.
    ASSIGN msg0111r-ParametroGlobal.TipoDado = 1
           msg0111r-ParametroGlobal.valor    = msg0111-aux.valor.

    ASSIGN resultado.sucesso = YES.


END.
ELSE 
    ASSIGN resultado.sucesso = NO.
