
{esp/esb/out/msg0111.i}

DEF TEMP-TABLE tt-globais
    FIELD classificacao AS CHAR
    FIELD categoria     AS CHAR
    FIELD beneficio     AS CHAR
    FIELD unid-neg      AS CHAR 
    FIELD tipo-param    AS INTE
    FIELD valor         AS CHAR
    FIELD tipo-dado     AS INT. /**/

RUN pi-Buscar-Parametro ( ?,   /*CLASSIFICACAO*/       
                          ?,   /*COMPROMISSO*/         
                          ?,   /*CATEGORIA*/           
                          ?,   /*BENEFICIO*/           
                         21,   /*TIPO DE PAR∂METRO*/   
                          ?,   /*N÷VEL P‡S-VENDA*/     
                         "INV" /*UNIDADE DE NEG‡CIO*/ ).

PROCEDURE pi-Buscar-Parametro:

    DEFINE  INPUT  PARAM p-classificacao        AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-compromisso          AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-Categoria            AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-Beneficio            AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-TipoParametroGlobal  AS INT  NO-UNDO.
    DEFINE  INPUT  PARAM p-CodigoNivelPosVenda  AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-CodigoUnidadeNegocio AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE resultado.
    EMPTY TEMP-TABLE msg0111r-ParametroGlobal.
    
    RUN esp/esb/out/msg0111.p (INPUT  p-Classificacao,        /*CLASSIFICACAO*/
                               INPUT  p-compromisso,          /*COMPROMISSO*/
                               INPUT  p-Categoria,            /*CATEGORIA*/
                               INPUT  p-Beneficio,            /*BENEFICIO*/
                               INPUT  p-TipoParametroGlobal,  /*TIPO DE PAR∂METRO*/
                               INPUT  p-CodigoNivelPosVenda,  /*N÷VEL P‡S-VENDA*/
                               INPUT  p-CodigoUnidadeNegocio, /*UNIDADE DE NEG‡CIO*/
                               OUTPUT TABLE resultado,
                               OUTPUT TABLE msg0111r-ParametroGlobal).
    
    FIND FIRST resultado NO-ERROR.
    
    MESSAGE "resultado: " AVAIL resultado
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    IF  AVAIL resultado AND resultado.sucesso THEN DO:
        FIND FIRST msg0111r-ParametroGlobal NO-ERROR.
    
        IF  AVAIL msg0111r-ParametroGlobal THEN DO:
    
            CREATE tt-globais.
            ASSIGN tt-globais.classificacao  = p-Classificacao                      
                   tt-globais.categoria      = p-Categoria                          
                   tt-globais.beneficio      = p-Beneficio                          
                   tt-globais.unid-neg       = p-CodigoUnidadeNegocio               
                   tt-globais.tipo-param     = p-TipoParametroGlobal                
                   tt-globais.tipo-dado      = msg0111r-ParametroGlobal.TipoDado    
                   tt-globais.valor          = msg0111r-ParametroGlobal.valor.
            
              MESSAGE "msg0111r-ParametroGlobal.TipoDado: "  msg0111r-ParametroGlobal.TipoDado SKIP
                      "msg0111r-ParametroGlobal.Valor...: "  msg0111r-ParametroGlobal.Valor
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE
            RETURN "NOK".
    END.
    ELSE 
        RETURN "OK".
    

    RETURN "OK".

END.
