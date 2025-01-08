&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE EXEC-RPC YES
{esp/es0478-rpc.i}
{esp/es0478.i "new"}
{esp/es0018.i}
{utp/ut-glob.i}
DEF TEMP-TABLE tt-usuar-quebra  LIKE tt-prog-ponto.

def temp-table tt-item NO-UNDO
    field it-codigo     like item.it-codigo
    field nr-ae         like ae-item.nr-ae
    field sequencia     like ae-item.sequencia
    field quantidade    like ae-item.quantidade
    field localizacao   like ae-item.localizacao
    field cod-depos     like deposito.cod-depos.

DEF VAR c-etiqueta          AS CHAR NO-UNDO.
DEF VAR c-codigo            AS CHAR NO-UNDO.
DEF VAR c-deposito          LIKE deposito.cod-depos NO-UNDO.
DEF VAR c-dep-e             LIKE deposito.cod-depos NO-UNDO.
DEF VAR c-it-codigo         LIKE item.it-codigo.
DEF VAR c-msg-erro          AS CHAR FORMAT "x(70)".
DEF VAR c-ae                AS CHAR NO-UNDO.
DEF VAR c-sequencia         AS CHAR NO-UNDO.
DEF VAR i-emitente          LIKE emitente.cod-emitente NO-UNDO.
DEF VAR i-quantidade        AS DEC NO-UNDO.
DEF VAR l-aba               AS LOG NO-UNDO.
DEF VAR l-erro              AS LOG NO-UNDO.
DEF VAR i-nr-linha          LIKE item.nr-linha NO-UNDO.
DEF VAR l-congelado         AS LOG NO-UNDO.
DEF VAR i-nr-req            AS INTEGER NO-UNDO.
DEF VAR c-localizacao       AS CHAR NO-UNDO.
DEF VAR i-roteiro           AS INT NO-UNDO.
DEF VAR i-nf                LIKE ae-item.nf NO-UNDO.
def var c-loc-dev like movto-estoq.cod-localiz NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.



    DEF VAR i-nome-programa AS CHAR.
    DEF VAR i-ponto AS INT.
    DEF VAR i-sequencia AS INT.
    DEF VAR i-conteudo AS CHAR.

{upc/btb910za-upc.i} /* v_cod_estab_usuar */

{esp/btb/esbtb003.i} /* pi-busca-estab */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 21.13
         WIDTH              = 50.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-atualizaEstabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaEstabel Procedure 
PROCEDURE atualizaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR    NO-UNDO.


    ASSIGN v_cod_estab_usuar = p-cod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-atualizaLocalEntrada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaLocalEntrada Procedure 
PROCEDURE atualizaLocalEntrada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-local AS CHAR NO-UNDO.

    c-loc-dev = p-local.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-baixaRequisicao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE baixaRequisicao Procedure 
PROCEDURE baixaRequisicao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR l-fecha AS LOGICAL NO-UNDO INIT YES.

   find first it-requisicao EXCLUSIVE-LOCK
        where it-requisicao.it-codigo     = c-it-codigo
          and it-requisicao.nr-requisicao = i-nr-req no-error.
   if avail it-requisicao then do:
      if it-requisicao.qt-a-atender >= i-quantidade then do:
         assign it-requisicao.qt-atendida = it-requisicao.qt-atendida +
                                            i-quantidade
                it-requisicao.qt-a-atender = it-requisicao.qt-a-atender -
                                             i-quantidade
                it-requisicao.dt-atend = today                             .
         if it-requisicao.qt-a-atender <= 0 then 
            assign it-requisicao.situacao = 2.
                         
         for each it-requisicao no-lock
             where it-requisicao.nr-requisicao = i-nr-req
               and it-requisicao.situacao = 1:
             assign l-fecha = no.
         end.
                         
         if l-fecha then do:
            find requisicao where requisicao.nr-requisicao = i-nr-req EXCLUSIVE-LOCK.
            assign requisicao.situacao = 2.
            RELEASE requisicao.
         end.
      end.
      RELEASE it-requisicao.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checa-linha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checa-linha Procedure 
PROCEDURE checa-linha PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR de-saldo-linha      LIKE saldo-estoq.qtidade-atu NO-UNDO.

    assign l-erro = no.
    
    /* checa linha/capacidade */

    if  c-deposito <> "PDO" 
    and c-deposito <> "EXP" 
    and c-deposito <> "ACA" 
    and c-deposito <> "AST" 
    and c-deposito <> "REJ" then do:
        /*
        if  (c-deposito = "SMD" or c-deposito = "IAO" or c-deposito = "IAC"
        or c-deposito = "IAS" or c-deposito = "IAT" or c-deposito = "COB")
        and (weekday(today) = 1 or weekday(today) = 7) then do:
           assign c-msg-erro = substitute("Dep¢sito &1 n∆o pode ser movimentado no final de semana",TRIM(c-deposito)).
           run trata-erro.
           assign l-erro = yes.
           RETURN "NOK".
        end.
        */
        /* checa relacao do item com a linha */
        
        find linha-item no-lock
          where linha-item.cod-estabel = v_cod_estab_usuar
            AND linha-item.it-codigo = item.it-codigo
            and linha-item.nr-linha   = i-nr-linha no-error.
        if not avail linha-item then do:
           assign c-msg-erro = substitute("Item &1 n∆o Ç utilizado na linha &2 no estabelecimento &3",
                                          TRIM(item.it-codigo),
                                          STRING(i-nr-linha),
                                          v_cod_estab_usuar). 
           run trata-erro.
           assign l-erro = yes.
           RETURN "NOK".
        end.
        else do:
            /* verifica se a transferencia nao excedera cap. linha */
            assign de-saldo-linha = 0.
            for each saldo-estoq no-lock
               where saldo-estoq.cod-estabel = v_cod_estab_usuar
                 and saldo-estoq.cod-depos = c-deposito
                 AND saldo-estoq.it-codigo = item.it-codigo:
                 assign de-saldo-linha = de-saldo-linha + saldo-estoq.qtidade-atu.
            end.
            if de-saldo-linha + i-quantidade > linha-item.maximo
               then do:
                 assign c-msg-erro = substitute("Transferància excede capacidade da linha &1|", STRING(i-nr-linha))   +
                                     "Item.......: "   + item.it-codigo                +
                                     "~nSaldo......: " + string(de-saldo-linha)        +  
                                     "~nInformado..: " + string(i-quantidade)          +    
                                     "~nM†ximo.....: " + string(linha-item.maximo). 
                 run trata-erro. 
                 assign l-erro = yes.
                 RETURN "NOK".
            end.
        end.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-congelado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE congelado Procedure 
PROCEDURE congelado PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter co-it-codigo like item.it-codigo.
    def input parameter co-cod-depos like saldo-estoq.cod-depos.
    def input parameter co-localizacao like saldo-estoq.cod-localiz.

    if co-localizacao <> ? then do:
        find saldo-estoq no-lock
             where saldo-estoq.cod-estabel = v_cod_estab_usuar
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo
               and saldo-estoq.cod-localiz = co-localizacao no-error.
        if not avail saldo-estoq then do:
            assign l-congelado = no.
            RETURN "NOK".
        end.
        ELSE DO:
            find int-saldo-estoq no-lock 
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                assign l-congelado = yes.
            else    
                assign l-congelado = no.
        END.
    end.
    else do:
        assign l-congelado = no.
        for each saldo-estoq FIELDS(cod-estabel cod-depos it-codigo cod-localiz) no-lock 
             where saldo-estoq.cod-estabel = v_cod_estab_usuar
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo :
            find int-saldo-estoq no-lock 
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                assign l-congelado = yes.

        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaCB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaCB Procedure 
PROCEDURE decodificaCB PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-digito            AS INT NO-UNDO.
    DEF VAR c-quantidade        AS CHAR NO-UNDO.
    DEF VAR i-it-digito         AS INT NO-UNDO.
    DEF VAR i-cod-emitente      LIKE emitente.cod-emitente NO-UNDO.
    DEF VAR i-sequencia         AS INT NO-UNDO.
    DEF VAR c-linha             AS CHAR NO-UNDO.

    if  length(trim(c-codigo)) = 23 then do:
        assign c-digito     = int(substring(c-codigo,23,1))
               c-it-codigo  = substring(c-codigo,1,7) 
               c-quantidade = substring(c-codigo,8,5) 
               i-quantidade = INT(c-quantidade)
               c-ae         = substring(c-codigo,13,7)
               c-sequencia  = substring(c-codigo,20,3)
               c-linha      = c-it-codigo + c-quantidade + c-ae + c-sequencia.

    end.
    else do: /* 26 digitos */
        assign c-it-codigo  = substring(c-codigo,7,7)
               c-quantidade = substring(c-codigo,14,6)
               c-digito     = int(substring(c-codigo,26,1))
               c-linha      = substring(c-codigo,1,25).
       
        assign i-cod-emitente = int(substring(c-codigo,1,6))
               i-quantidade   = int(substring(c-codigo,14,6))
               i-sequencia    = int(substring(c-codigo,20,6)).
    end.

    run esp/es0135.r (input c-linha, output i-it-digito).
    IF c-digito <> i-it-digito THEN DO:
        ASSIGN c-msg-erro = "Digito verificador n∆o confere - Erro na leitura".
        RUN trata-erro.
        RETURN "NOK".
    END.
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-def-emit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE def-emit Procedure 
PROCEDURE def-emit PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     find ficha-cq no-lock
          where ficha-cq.nr-ficha = ae-item.roteiro no-error.
     if avail ficha-cq then 
         assign i-emitente = ficha-cq.cod-emitente.
     else
         assign i-emitente = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-efetivaDevolucao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaDevolucao Procedure 
PROCEDURE efetivaDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nf AS INT NO-UNDO.
    DEF INPUT PARAM p-contenedor AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-etiqueta AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dispositivo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR c-historico AS CHAR NO-UNDO.

    DEFINE VARIABLE dt-validade AS DATE        NO-UNDO.

    do transaction:
        if avail ficha-cq 
            then assign i-emitente = ficha-cq.cod-emitente.
            else assign i-emitente = 0.

    /*
    if c-dep-e = "smd" then assign c-loc-dev = "".
    else  
    assign c-loc-dev =  if (c-deposito = "plc" 
                        or c-deposito = "tel" 
                        or c-deposito = "isf" 
                        or c-deposito = "smd" 
                        or c-deposito = "inj" 
                        or c-deposito = "esp" 
                        or c-deposito = "cnt" 
                        or c-deposito = "pci" 
                        or c-deposito = "psf" 
                        or c-deposito = "pes" 
                        or c-deposito = "mes" 
                        or c-deposito = "cst") then "DEVOLUCAO" else "".
    */                    

        assign c-historico = p-etiqueta  + " - " + string(today) + " - " + string(time,"HH:MM:SS").
 
        ASSIGN dt-validade = ?.
        IF c-dep-e = "ALM" THEN DO:
            /*caso seja devoluá∆o para ALM calcula validade da AE pela metade 30 / 2 */
            FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
            IF AVAIL ITEM THEN DO:
                FOR FIRST familia NO-LOCK 
                    WHERE familia.fm-codigo = ITEM.fm-codigo,
                    FIRST int-familia OF familia NO-LOCK:
                    ASSIGN dt-validade = TODAY + (int-familia.meses-validade * 15).
                END.
            END.
        END.

        run esp/es0478-n.p 
            (input c-it-codigo,        /* item */
             input c-deposito,         /* deposito de saida */                                  
             input c-localizacao,      /* local de saida */
             input i-quantidade,       /* quantidade total */
             input c-dep-e,            /* deposito de entrada */
             input 0,                  /* numero docto */
             input "DML",              /* serie */
             input c-historico,        /* historico */
             input 0,                  /* numero do AE */
             input 0,                  /* sequencia do AE */
             input i-roteiro,          /* roteiro */  
             input p-nf,               /* nota */
             input no,                 /* baixa parcial */
             input yes,                /* devolucao ou transferencia */
             input p-contenedor,       /* contenedor */
             input i-emitente,         /* fornecedor */
             input 1,                  /* sequencia inicial */
             input ((c-deposito = "plc" or
                    c-deposito = "tel" or
                    c-deposito = "isf" or
                    c-deposito = "smd" or
                    c-deposito = "iao" or
                    c-deposito = "iac" or
                    c-deposito = "ias" or
                    c-deposito = "iat" or
                    c-deposito = "cob" or
                    c-deposito = "inj" or
                    c-deposito = "esp" or
                    c-deposito = "cnt" or
                    c-deposito = "pci" or
                    c-deposito = "psf" or
                    c-deposito = "pes" or
                    c-deposito = "mes" or
                    c-deposito = "cst" or
                    c-deposito = "dsk" or
                    c-deposito = "sec") and
                    c-dep-e <> "tam"),  /* usa local informado */     
             input c-loc-dev ,          /* local informado */
             input today,              /* data movto-estoq */
             input dt-validade,        /* Validade da AE */
             INPUT "," + p-dispositivo,
             input v_cod_estab_usuar,
             output table tt-etiqueta,
             OUTPUT p-msg-erro).
 
        if l-deu-erro then do:
              assign c-msg-erro = "Ocorreu um erro na transferància" .
              run trata-erro.
              RETURN "NOK".
        end.
    end.
 
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-efetivaParcial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaParcial Procedure 
PROCEDURE efetivaParcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-quantidade AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-contenedor AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-etiqueta AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dispositivo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR c-historico AS CHAR NO-UNDO.


    i-quantidade = p-quantidade.

    run checa-linha.

    IF l-erro THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK".
    END.

    do transaction:
        ASSIGN i-emitente = 0.
        
        RUN def-emit. /* define fornecedor */

        assign c-historico = p-etiqueta  + " - " + string(today) + " - " + string(time,"HH:MM:SS").

        run esp/es0478-n.p 
            (input c-it-codigo,              /* item */
             input ae-item.cod-depos,  
             input c-localizacao,            /* local de saida */
             input p-quantidade,             /* quantidade total */
             input c-deposito,               /* deposito de entrada */
             input int(c-ae),                /* numero docto */
             input c-sequencia,              /* serie */
             input c-historico,              /* historico */
             input int(c-ae),                /* numero do AE */
             input int(c-sequencia),         /* sequencia do AE */
             input i-roteiro,                /* roteiro */  
             input i-nf,                     /* nota */
             input yes,                      /* baixa parcial */
             input no,                       /* devolucao ou transferencia */
             input p-contenedor,             /* contenedor */
             input i-emitente,               /* fornecedor */
             input 1,                        /* sequencia inicial */
             input no,                       /* usa local informado */
             input "",                       /* local informado */
             input today,                    /* data movto-estoq */
             input ?,                        /* Validade da AE */
             INPUT "," + p-dispositivo,
             input v_cod_estab_usuar,
             output table tt-etiqueta,
             OUTPUT p-msg-erro).   
          
        if l-deu-erro then do:
              assign c-msg-erro = "Ocorreu um erro na transferància" .
              run trata-erro.
              RETURN "NOK".
        end.
    end. 

    
    EMPTY TEMP-TABLE tt-item.
    create tt-item.
    assign tt-item.it-codigo    = item.it-codigo
           tt-item.nr-ae        = ae-item.nr-ae
           tt-item.sequencia    = ae-item.sequencia
           tt-item.quantidade   = i-quantidade
           tt-item.localizacao  = ae-item.localizacao
           tt-item.cod-depos    = c-deposito.

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-efetivaPreFormados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaPreFormados Procedure 
PROCEDURE efetivaPreFormados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-dispositivo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR c-historico AS CHAR NO-UNDO.

    do transaction:
        ASSIGN i-emitente = 0.
        
        RUN def-emit. /* define fornecedor */

        assign c-historico = c-etiqueta  + " - " + string(today) + " - " + string(time,"HH:MM:SS").

        run esp/es0478-n.p
            (input c-it-codigo,              /* item */
             input ae-item.cod-depos,        /* "alm", */  /* deposito de saida */    
             input ae-item.localizacao,      /* local de saida */
             input i-quantidade,             /* quantidade total */
             input c-deposito,               /* deposito de entrada */
             input int(c-ae),                /* numero docto */
             input c-sequencia,              /* serie */
             input c-historico,              /* historico */
             input int(c-ae),                /* numero do AE */
             input int(c-sequencia),         /* sequencia do AE */
             input ae-item.roteiro,          /* roteiro */  
             input 0,                        /* nota */
             input no,                       /* baixa parcial */
             input no,                       /* devolucao ou transferencia */
             input 0,                        /* contenedor */
             input i-emitente,               /* fornecedor */
             input 1,                        /* sequencia inicial */
             input yes,                      /* usa local informado */
             input item-local.localizacao,   /* local informado */
             input today,                    /* data movto-estoq */
             input ?,                        /* Validade da AE */
             INPUT "," + p-dispositivo,
             input v_cod_estab_usuar,
             output table tt-etiqueta,
             OUTPUT p-msg-erro).   
          
        if l-deu-erro then do:
              assign c-msg-erro = "Ocorreu um erro na transferància" .
              run trata-erro.
              RETURN "NOK".
        end.
    end. 

    
    EMPTY TEMP-TABLE tt-item.
    create tt-item.
    assign tt-item.it-codigo    = item.it-codigo
           tt-item.nr-ae        = ae-item.nr-ae
           tt-item.sequencia    = ae-item.sequencia
           tt-item.quantidade   = ae-item.quantidade
           tt-item.localizacao  = ae-item.localizacao
           tt-item.cod-depos    = c-deposito.

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-efetivaTransferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaTransferencia Procedure 
PROCEDURE efetivaTransferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-etiqueta AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dispositivo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR c-historico AS CHAR NO-UNDO.

    do transaction:
        ASSIGN i-emitente = 0.
        
        RUN def-emit. /* define fornecedor */

        assign c-historico = p-etiqueta  + " - " + string(today) + " - " + string(time,"HH:MM:SS")
               l-deu-erro  = NO.

        run esp/es0478-n.p 
            (input c-it-codigo,              /* item */
             input ae-item.cod-depos,  
             input ae-item.localizacao,      /* local de saida */
             input i-quantidade,             /* quantidade total */
             input c-deposito,               /* deposito de entrada */
             input int(c-ae),                /* numero docto */
             input c-sequencia,              /* serie */
             input c-historico,              /* historico */
             input int(c-ae),                /* numero do AE */
             input int(c-sequencia),         /* sequencia do AE */
             input ae-item.roteiro,          /* roteiro */  
             input 0,                        /* nota */
             input no,                       /* baixa parcial */
             input no,                       /* devolucao ou transferencia */
             input 0,                        /* contenedor */
             input i-emitente,               /* fornecedor */
             input 1,                        /* sequencia inicial */
             input c-deposito = "inj",       /* usa local informado */
             input "",                       /* local informado */
             input today,                    /* data movto-estoq */
             input ?,                        /* Validade da AE */
             INPUT "," + p-dispositivo,
             input v_cod_estab_usuar,
             output table tt-etiqueta,
             OUTPUT p-msg-erro).   
          
        if l-deu-erro then do:
              assign c-msg-erro = "Ocorreu um erro na transferància" .
              run trata-erro.
              RETURN "NOK".
        end.
    end. 

    
    EMPTY TEMP-TABLE tt-item.
    create tt-item.
    assign tt-item.it-codigo    = item.it-codigo
           tt-item.nr-ae        = ae-item.nr-ae
           tt-item.sequencia    = ae-item.sequencia
           tt-item.quantidade   = ae-item.quantidade
           tt-item.localizacao  = ae-item.localizacao
           tt-item.cod-depos    = c-deposito.

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-recuperaNarrativa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recuperaNarrativa Procedure 
PROCEDURE recuperaNarrativa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-narrativa AS CHAR NO-UNDO.
    DEF VAR i AS INT NO-UNDO.

    IF AVAIL ae-bloqueado THEN DO i = 1 TO 4:
        p-narrativa = p-narrativa + ae-bloqueado.narrativa[i] + "|".
    END.
    SUBSTRING(p-narrativa, max(LENGTH(p-narrativa), 1), 1) = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recuperaRoteiro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recuperaRoteiro Procedure 
PROCEDURE recuperaRoteiro :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-item      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-deposito  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuario   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-roteiro   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nf        AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-item AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-nro-docto AS CHARACTER NO-UNDO.


    /*RUN pi-busca-estab(INPUT p-usuario).*/

    ASSIGN v_cod_estab_usuar = p-cod-estabel.

    FOR EACH  movto-estoq /* USE-INDEX data-item (ficou lento) */ NO-LOCK
        WHERE movto-estoq.it-codigo   = p-item
        AND   movto-estoq.cod-estabel = v_cod_estab_usuar
        AND   movto-estoq.cod-depos   = p-deposito
        AND   movto-estoq.esp-docto   = 33 /* TRA     */
        AND   movto-estoq.tipo-trans  = 1  /* ENTRADA */ 
        BY movto-estoq.nr-trans:

        assign c-nro-docto = movto-estoq.nro-docto.
    END.
        
    find first ae-item no-lock
         where ae-item.cod-estabel = v_cod_estab_usuar
         and   ae-item.nr-ae       = int(c-nro-docto) no-error.
    if avail ae-item
    THEN assign p-roteiro = ae-item.roteiro
                p-nf      = ae-item.nf.
    ELSE assign p-roteiro = 0
                p-nf      = 0.
   
    
    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = p-item NO-ERROR.
    IF AVAIL ITEM THEN p-desc-item = ITEM.desc-item.
    

    /*------------------------------------------------------------
    find first ae-item no-lock
         where ae-item.cod-estabel = v_cod_estab_usuar
           and ae-item.it-codigo = p-item
           and not ae-item.situacao no-error.
    if avail ae-item
       then assign p-roteiro = ae-item.roteiro
                   p-nf      = ae-item.nf.
    /* Sim, isto n∆o deveria estar aqui, mas por quest∆o de
       eficiància, por que n∆o? */
    --------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recuperaTT-Etiqueta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recuperaTT-Etiqueta Procedure 
PROCEDURE recuperaTT-Etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-etiqueta.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recuperaTT-Item) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recuperaTT-Item Procedure 
PROCEDURE recuperaTT-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-item.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trata-erro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trata-erro Procedure 
PROCEDURE trata-erro PRIVATE :
DEF VAR i-saldo-ae LIKE ae-item.quantidade FORMAT ">>>,>>>,>>9" NO-UNDO.
def buffer b-ae-item for ae-item.

if c-it-codigo <> "" then do:
        find item where item.it-codigo = c-it-codigo no-lock no-error.
        if avail item then do:
            output to value(session:TEMP-DIRECTORY + "escep013rpc.log") APPEND CONVERT TARGET SESSION:CHARSET.
                disp "==> " item.it-codigo format "x(7)"
                            item.desc-item format "x(36)"   skip
                            "AE: " c-ae "Seq.:" c-sequencia skip
                            "    "  c-msg-erro FORMAT "x(131)" skip
                            with width 300 no-labels frame f-imp-erro.
                for each saldo-estoq no-lock
                   where saldo-estoq.cod-estabel = v_cod_estab_usuar
                     AND saldo-estoq.it-codigo = c-it-codigo :
                    disp "    Saldo Alm:"  saldo-estoq.qtidade-atu 
                         saldo-estoq.cod-localiz skip 
                         with frame f-imp-erro.

                end.
                assign i-saldo-ae = 0.
                for each b-ae-item NO-LOCK
                   where b-ae-item.cod-estabel = v_cod_estab_usuar
                   and b-ae-item.it-codigo = c-it-codigo:
                    assign i-saldo-ae = i-saldo-ae + b-ae-item.quantidade.
                end.
                disp "     Saldo AE: " i-saldo-ae skip
                     "      Usuario: " c-seg-usuario  skip
                     "    Data/Hora: " today " - " string(time,"HH:MM:SS")
                     with frame f-imp-erro.       
            output close.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaDevolucao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDevolucao Procedure 
PROCEDURE validaDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-usuario AS CHAR NO-UNDO.
    DEF INPUT PARAM p-deposito AS CHAR NO-UNDO.
    DEF INPUT PARAM p-deposito-entrada AS CHAR NO-UNDO.
    DEF INPUT PARAM p-item AS CHAR NO-UNDO.
    DEF INPUT PARAM p-roteiro AS INT NO-UNDO.
    DEF INPUT PARAM p-localizacao AS CHAR NO-UNDO.
    DEF INPUT PARAM p-quantidade AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR l-perm              AS LOGICAL NO-UNDO.


    ASSIGN i-roteiro     = p-roteiro
           c-localizacao = p-localizacao
           c-deposito    = p-deposito
           c-dep-e       = p-deposito-entrada
           c-it-codigo   = p-item
           i-quantidade  = p-quantidade
           c-seg-usuario = p-usuario.

    /*RUN pi-busca-estab(INPUT p-usuario).*/

    ASSIGN v_cod_estab_usuar = p-cod-estabel.

    FIND item NO-LOCK 
         WHERE item.it-codigo = c-it-codigo NO-ERROR.
    IF NOT AVAIL item THEN DO:
        ASSIGN c-msg-erro = "Item n∆o Cadastrado: " + c-it-codigo
               p-msg-erro = c-msg-erro.
        RUN trata-erro.
        RETURN "NOK".
    END.
    
    RUN esp/es0590a.r (INPUT "escep013", 
                       INPUT p-deposito,
                       INPUT NO, /*saida */
                       INPUT p-usuario,
                       OUTPUT l-perm).

    IF NOT l-perm THEN DO:
        p-msg-erro = "Usu†rio sem autorizaá∆o~nMovimento cancelado|Solicitar acesso ao L°der de Operaá‰es LOG÷STICAS".
        RETURN "NOK". 
    END.
    
    if p-deposito <> "HML" then do: 
        find first saldo-estoq no-lock 
             where saldo-estoq.it-codigo    = p-item
               and saldo-estoq.cod-depos    = p-deposito
               and saldo-estoq.cod-localiz  = ""               
               and saldo-estoq.cod-estabel  = v_cod_estab_usuar 
               AND saldo-estoq.qtidade-atu <> 0 no-error.

        if NOT AVAIL saldo-estoq OR saldo-estoq.qtidade-atu < p-quantidade then do:
            ASSIGN c-msg-erro = "A quantidade solicitada Ç maior que o saldo " +
                                "dispon°vel: " + string(IF AVAIL saldo-estoq THEN saldo-estoq.qtidade-atu ELSE 0) + "~n" +
                                "Devoluá∆o cancelada"
                   p-msg-erro = c-msg-erro.

            RETURN "NOK". 
        end.
    end.
            
    find ficha-cq no-lock
        where ficha-cq.nr-ficha = p-roteiro no-error.
    
    if c-deposito = "hml" then do:
        if not avail ficha-cq then do:
            ASSIGN c-msg-erro = "Roteiro n∆o est† cadastrado"
                   p-msg-erro = c-msg-erro.
            RETURN "NOK". 
        end.
        if ficha-cq.it-codigo <> p-item then do:
            ASSIGN c-msg-erro = substitute("O roteiro &1 n∆o pertence ao item informado", STRING(p-roteiro)).
                   p-msg-erro = c-msg-erro.
            RETURN "NOK". 
        end.
    end.             

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaEtiqueta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiqueta Procedure 
PROCEDURE validaEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     Decodifica e valida a etiqueta informada pelo usu†rio, a qual
               contÇm o dep¢sito de entrada 
  Parameters:  Entrada:     
               p-testa-deposito: yes se deve testar a permiss∆o de acesso ao
               dep¢sito pelo usu†rio informado
               p-etiqueta: a etiqueta informada
               p-usuario: nome do usu†rio
               Sa°da:
               p-deposito: dep¢sito de entrada   
               p-msg-erro: mensagem de erro quando n∆o for bem sucedido
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-testa-deposito AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-etiqueta AS CHAR NO-UNDO.
    DEF INPUT PARAM p-usuario AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-deposito AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    DEF VAR l-perm              AS LOG NO-UNDO.

    ASSIGN c-deposito    = ""
           c-etiqueta    = p-etiqueta
           c-seg-usuario = p-usuario.

    /*RUN pi-busca-estab(INPUT p-usuario).*/
          
    ASSIGN v_cod_estab_usuar = p-cod-estabel.

    /* decodifica a etiqueta */
    ASSIGN c-deposito = c-etiqueta
           l-aba = YES.
        
    IF NOT l-aba THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK". 
    END.

    IF p-testa-deposito THEN DO:
        RUN esp/es0590a.r (INPUT "escep013", 
                           INPUT c-deposito,
                           INPUT YES, /* entrada */
                           INPUT p-usuario,
                           OUTPUT l-perm).

        IF NOT l-perm THEN DO:
            p-msg-erro = "Usu†rio sem autorizaá∆o~nMovimento cancelado|Solicitar acesso ao L°der de Operaá‰es LOG÷STICAS".
                         
            RETURN "NOK". 
        END.
    END.

    ASSIGN p-deposito    = c-deposito.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaLocalEntrada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaLocalEntrada Procedure 
PROCEDURE validaLocalEntrada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-local AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

    IF NOT CAN-FIND(FIRST mgcad.localizacao NO-LOCK
                    WHERE mgcad.localizacao.cod-localiz = p-local) THEN DO:
        assign c-msg-erro = "Localizaá∆o de Entrada n∆o cadastrada"
               p-msg-erro = c-msg-erro.
        run trata-erro.
        RETURN "NOK". 

    END.
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaParcial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaParcial Procedure 
PROCEDURE validaParcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-usuario AS CHAR NO-UNDO.
    DEF INPUT PARAM p-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-deposito AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.
    
    DEF VAR da-prox-ae-item     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR da-prox-ae-forn     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR c-anterior          AS CHAR NO-UNDO.
    /*DEF VAR l-dep-parcial       AS LOG NO-UNDO.*/

    ASSIGN c-deposito    = p-deposito
           c-codigo      = p-codigo
           c-seg-usuario = p-usuario.

    /*RUN pi-busca-estab(INPUT p-usuario).*/

    ASSIGN v_cod_estab_usuar = p-cod-estabel.
    
    RUN decodificaCB.

    IF RETURN-VALUE = "NOK" THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK".
    END.

    FIND FIRST ITEM NO-LOCK WHERE
         item.it-codigo = c-it-codigo no-error. 
    IF NOT AVAIL ITEM THEN DO:
       ASSIGN c-msg-erro = "Item n∆o Cadastrado: " + c-it-codigo
              p-msg-erro = c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    FOR EACH ae-item USE-INDEX fifo NO-LOCK      WHERE
             ae-item.cod-estabel = v_cod_estab_usuar and 
             ae-item.it-codigo  = item.it-codigo AND
             ae-item.situacao   = NO             AND
             ae-item.cod-depos  = "alm":    
        FIND FIRST ae-bloqueado WHERE
                   ae-bloqueado.cod-estabel = ae-item.cod-estabel and 
                   ae-bloqueado.nr-ae = ae-item.nr-ae NO-LOCK NO-ERROR.
        IF NOT AVAIL ae-bloqueado THEN DO:
           ASSIGN da-prox-ae-item = ae-item.data
                   c-anterior      = " AE " + string(ae-item.nr-ae) + "-" 
                                            + string(ae-item.data)  + " - " + ae-item.localizacao.
           LEAVE.
        END.
    END.

    FIND ae-item NO-LOCK                      WHERE
         ae-item.cod-estabel = v_cod_estab_usuar and
         ae-item.nr-ae     = int(c-ae)        AND
         ae-item.sequencia = int(c-sequencia) NO-ERROR.

    /* verifica validade */
    IF AVAIL ae-item                    AND
             ae-item.situacao = NO      AND
             ae-item.data-validade <> ? THEN DO:
       IF ae-item.data-validade < TODAY THEN DO:
          ASSIGN c-msg-erro = "AE fora da Validade"
                   p-msg-erro = c-msg-erro.
          RUN trata-erro.

          RETURN "NOK".
       END.
    END.
    
    /* Retirado a pedido do Edu
    IF AVAIL ae-item                            AND
             ae-item.situacao = no              AND
             ae-item.it-codigo begins "164"     AND
             item.desc-item begins "kit manual" AND
             ae-item.data < today - 120         THEN DO:
        ASSIGN c-msg-erro = "Manual a mais de 4 meses no estoque. Consulte a Documentaá∆o" 
               p-msg-erro = c-msg-erro.
        RUN trata-erro.
        RETURN "NOK".
    END.
    */

    IF AVAIL ae-item AND
             ae-item.situacao = NO THEN DO:
      IF ae-item.data > da-prox-ae-forn OR 
         ae-item.data > da-prox-ae-item THEN DO:
         ASSIGN c-msg-erro = "Existe lote com data anterior" + c-anterior
                p-msg-erro = c-msg-erro.
         RUN trata-erro.
         
         RUN esp/es0018p.r (INPUT "ESCEP013",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-usuar-quebra).
         
         FIND FIRST tt-usuar-quebra
             WHERE tt-usuar-quebra.conteudo = p-usuario NO-ERROR.
         IF NOT AVAIL tt-usuar-quebra THEN DO:
            RETURN "NOK".
         END.
      END.
    END.
    ELSE DO:
        IF AVAIL ae-item THEN DO:
           /* ae ja baixado */
           ASSIGN c-msg-erro = "AE j† Baixado / Procure respons†vel do Almoxarifado"
                   p-msg-erro = c-msg-erro.
           RUN trata-erro.
           RETURN "NOK".
        END.
        ELSE DO:
           /* inexistente */
           ASSIGN c-msg-erro = "N∆o existe registro desta AE / AE CANCELADA / Procure respons†vel do Almoxarifado" 
                   p-msg-erro = c-msg-erro.
           RUN trata-erro.
           RETURN "NOK".
        END.
    END.

    /* verifica se AE esta bloqueado */
    FIND ae-bloqueado NO-LOCK                       WHERE
         ae-bloqueado.cod-estabel = ae-item.cod-estabel and
         ae-bloqueado.nr-ae       = ae-item.nr-ae       AND
         ae-bloqueado.sequencia   = ae-item.sequencia   AND 
         ae-bloqueado.it-codigo   = c-it-codigo         NO-ERROR.
    IF AVAIL ae-bloqueado THEN DO:
       ASSIGN c-msg-erro = "AE BLOQUEADO - Consulte o Respons†vel pelo Almoxarifado"
               p-msg-erro = c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    ASSIGN i-nr-linha = 0.
    
    /*FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.

    
    RUN esp/es0018p.p (INPUT "ESCEP013RPC", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).    

    for each tt-prog-ponto:
        if num-entries(tt-prog-ponto.conteudo) = 3
        and entry(1, tt-prog-ponto.conteudo) = v_cod_estab_usuar
        AND entry(2, tt-prog-ponto.conteudo) = p-deposito then do:
            i-nr-linha = int(entry(3, tt-prog-ponto.conteudo)).
            leave.
        end.    
    end.            
    */

    FOR FIRST int-lin-prod NO-LOCK
        WHERE int-lin-prod.cod-estabel    = v_cod_estab_usuar
        AND   int-lin-prod.deposito-saida = p-deposito:

        ASSIGN i-nr-linha = int-lin-prod.nr-linha.

    END.

    ASSIGN c-localizacao = ae-item.localizacao
           i-roteiro     = ae-item.roteiro
           i-nf          = ae-item.nf.

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaPreFormados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPreFormados Procedure 
PROCEDURE validaPreFormados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-usuario AS CHAR NO-UNDO.
    DEF INPUT PARAM p-codigo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.
    
    DEF VAR l-perm              AS LOGICAL NO-UNDO.
    DEF VAR da-prox-ae-item     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR da-prox-ae-forn     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR c-anterior          AS CHAR NO-UNDO.

    ASSIGN c-codigo = p-codigo
           c-seg-usuario = p-usuario.

    /*RUN pi-busca-estab(INPUT p-usuario).*/

    ASSIGN v_cod_estab_usuar = p-cod-estabel.

    RUN esp/es0590a.r (input "escep013", 
                       input "alm",
                       input no, /*saida */
                       INPUT p-usuario,
                       output l-perm).
    IF NOT l-perm THEN DO:
       ASSIGN p-msg-erro = "Usu†rio sem autorizaá∆o~nMovimento cancelado|Solicitar acesso ao L°der de Operaá‰es LOG÷STICAS".
       RETURN "NOK". 
    END.

    ASSIGN c-deposito       = "alm". 
    
    RUN esp/es0590a.r (INPUT "escep013", 
                       INPUT c-deposito,
                       INPUT YES, /* entrada */
                       INPUT p-usuario,
                       OUTPUT l-perm).

    IF NOT l-perm THEN DO:
        p-msg-erro = "Usu†rio sem autorizaá∆o~nMovimento cancelado|Solicitar acesso ao L°der de Operaá‰es LOG÷STICAS".
        RETURN "NOK". 
    END.
    
    ASSIGN c-etiqueta = p-usuario + "- alm - PF"
           c-deposito = "alm"
           i-nr-linha = 0. 

    RUN decodificaCB.

    IF RETURN-VALUE = "NOK" THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK".
    END.

    FIND item NO-LOCK WHERE
         item.it-codigo = c-it-codigo NO-ERROR.
    IF NOT AVAIL item THEN DO:
       ASSIGN c-msg-erro = "Item n∆o Cadastrado: " + c-it-codigo
               p-msg-erro =  c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    FOR EACH ae-item USE-INDEX fifo NO-LOCK     WHERE
             ae-item.cod-estabel = v_cod_estab_usuar and
             ae-item.it-codigo = item.it-codigo AND
             ae-item.situacao  = no             AND
             ae-item.cod-depos = "alm":
        FIND FIRST ae-bloqueado WHERE
                   ae-bloqueado.cod-estabel = ae-item.cod-estabel and
                   ae-bloqueado.nr-ae = ae-item.nr-ae NO-LOCK NO-ERROR.
        IF NOT AVAIL ae-bloqueado THEN DO:
           ASSIGN da-prox-ae-item = ae-item.data
                  c-anterior      = " AE " + string(ae-item.nr-ae) + "-" + string(ae-item.data) + " - " + ae-item.localizacao.
           LEAVE.
        END.
    END.


    /* busca o ae lido */
    FIND ae-item NO-LOCK                      WHERE
         ae-item.cod-estabel = v_cod_estab_usuar and 
         ae-item.nr-ae     = int(c-ae)        AND
         ae-item.sequencia = int(c-sequencia) NO-ERROR.
    /* verifica validade */
    IF AVAIL ae-item                    AND 
             ae-item.situacao = NO      AND
             ae-item.data-validade <> ? THEN DO:
       IF ae-item.data-validade < today then do:
          ASSIGN c-msg-erro = "AE fora da Validade"
                   p-msg-erro =  c-msg-erro.
          RUN trata-erro.
          RETURN "NOK".
       END.
    END.

    IF AVAIL ae-item AND
             ae-item.quantidade <> i-quantidade THEN DO:
             ASSIGN c-msg-erro = "Quantidade AE Diferente da Quantidade Etiqueta"
                    p-msg-erro =  c-msg-erro.
             RUN trata-erro.
             RETURN "NOK".
    END.

    /* verifica se existe ae anterior */  
    IF AVAIL ae-item AND
             ae-item.situacao = NO THEN DO:
        /*IF NOT p-abastecedor BEGINS "ast" THEN DO:           */
           IF ae-item.data > da-prox-ae-forn OR 
              ae-item.data > da-prox-ae-item THEN DO:
              ASSIGN c-msg-erro = "Existe lote com data anterior" + c-anterior
                     p-msg-erro = c-msg-erro.
              RUN trata-erro.
              
              RUN esp/es0018p.r (INPUT "ESCEP013",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-usuar-quebra).

              FIND FIRST tt-usuar-quebra
                  WHERE tt-usuar-quebra.conteudo = p-usuario NO-ERROR.
              IF NOT AVAIL tt-usuar-quebra THEN DO:
                  RETURN "NOK".
              END.
           END.   
        /*END.*/
    END.
    ELSE DO:
       IF AVAIL ae-item THEN DO:
          /* ae ja baixado */
          ASSIGN c-msg-erro = "AE j† Baixado / Procure respons†vel do Almoxarifado"
                 p-msg-erro =  c-msg-erro.
          RUN trata-erro.
          RETURN "NOK".
       END.
       ELSE DO:
          /* inexistente */
          ASSIGN c-msg-erro = "N∆o existe registro desta AE / AE CANCELADA / Procure respons†vel do Almoxarifado" 
                 p-msg-erro =  c-msg-erro.
          RUN trata-erro.
          RETURN "NOK".
       END.
    END.

    /* verifica se AE esta bloqueado */
    FIND ae-bloqueado NO-LOCK                       WHERE
         ae-bloqueado.cod-estabel = ae-item.cod-estabel and 
         ae-bloqueado.nr-ae     = ae-item.nr-ae     AND
         ae-bloqueado.sequencia = ae-item.sequencia AND  
         ae-bloqueado.it-codigo = c-it-codigo       NO-ERROR.
    IF AVAIL ae-bloqueado THEN DO:
       ASSIGN c-msg-erro = "AE BLOQUEADO - Consulte o Respons†vel pelo Almoxarifado"
              p-msg-erro =  c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    FIND first item-local 
         WHERE item-local.it-codigo = c-it-codigo 
           and item-local.cod-estabel = ae-item.cod-estabel
           and item-local.cod-depos = "alm"         
           and item-local.cod-tipo  = 99 NO-LOCK NO-ERROR.
    IF NOT AVAIL item-local THEN DO:
       ASSIGN c-msg-erro = "Item n∆o est† registrado nos locais de pre-forma"
              p-msg-erro =  c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    RUN congelado(input ae-item.it-codigo,
                  input "alm",
                  input ae-item.localizacao).
    IF l-congelado then do:
       ASSIGN c-msg-erro = "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio."
               p-msg-erro =  c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.

    RUN congelado(input ae-item.it-codigo,
                  input c-deposito,
                  input item-local.localizacao).

    IF l-congelado then do:
       ASSIGN c-msg-erro = "Item/Dep¢sito/Localizá∆o de Destino Congelada para Invent†rio."
               p-msg-erro =  c-msg-erro.
       RUN trata-erro.
       RETURN "NOK".
    END.
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-validaTransferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaTransferencia Procedure 
PROCEDURE validaTransferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-usuario AS CHAR NO-UNDO.
    DEF INPUT PARAM p-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-deposito AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.
    
    DEF VAR da-prox-ae-item     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR da-prox-ae-forn     AS DATE NO-UNDO INIT 12/31/9999.
    DEF VAR c-anterior          AS CHAR NO-UNDO.

    DEF BUFFER b2-ae-item for ae-item.

    ASSIGN c-deposito    = p-deposito
           c-codigo      = p-codigo
           c-seg-usuario = p-usuario.

    /*RUN pi-busca-estab(INPUT p-usuario).*/

    ASSIGN v_cod_estab_usuar = p-cod-estabel.
    
    /* decodifica o c¢digo de barras.
       atualiza as vari†veis c-it-codigo, i-quantidade, c-ae e c-sequencia */
    RUN decodificaCB.

    IF RETURN-VALUE = "NOK" THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK".
    END.
    
    FIND item NO-LOCK WHERE
         item.it-codigo = c-it-codigo NO-ERROR.
    IF NOT AVAIL item THEN DO:
        ASSIGN c-msg-erro = "Item n∆o Cadastrado: " + c-it-codigo
               p-msg-erro = c-msg-erro.
        RUN trata-erro.
        RETURN "NOK".
    END.

    FIND ae-item NO-LOCK                      WHERE
         ae-item.cod-estabel = v_cod_estab_usuar and 
         ae-item.nr-ae     = INT(c-ae)        AND
         ae-item.sequencia = INT(c-sequencia) NO-ERROR.

    IF AVAIL ae-item THEN DO:
       FOR EACH b2-ae-item USE-INDEX fifo NO-LOCK      WHERE
                b2-ae-item.cod-estabel = ae-item.cod-estabel and
                b2-ae-item.it-codigo = item.it-codigo  AND
                b2-ae-item.situacao  = NO AND
                b2-ae-item.cod-depos = ae-item.cod-depos:
            FIND FIRST ae-bloqueado NO-LOCK WHERE
                       ae-bloqueado.cod-estabel = b2-ae-item.cod-estabel and
                       ae-bloqueado.nr-ae = b2-ae-item.nr-ae NO-ERROR.
            IF NOT AVAIL ae-bloqueado THEN DO:
                ASSIGN da-prox-ae-item = b2-ae-item.data
                       c-anterior      = " AE "   + STRING(b2-ae-item.nr-ae) 
                                          + "-"   + STRING(b2-ae-item.data) 
                                          + " - " + b2-ae-item.localizacao.
                LEAVE.
            END.
        END.
    END.

    /* busca o ae lido */      
    IF AVAIL ae-item                      AND
             ae-item.situacao       = NO  AND
             ae-item.data-validade <> ?   THEN DO:
        IF ae-item.data-validade < today then do:
           ASSIGN c-msg-erro = "AE fora da Validade"
                  p-msg-erro = c-msg-erro.
           RUN trata-erro.
           RETURN "NOK".
        END.
    END.  

    IF AVAIL ae-item AND
             ae-item.quantidade <> i-quantidade THEN DO:
        ASSIGN c-msg-erro = "Quantidade AE Diferente da Quantidade Etiqueta"
               p-msg-erro = c-msg-erro.
        RUN trata-erro.
        RETURN "NOK".
    END.

    IF AVAIL ae-item AND
             ae-item.situacao = NO THEN DO:

        IF ae-item.data > da-prox-ae-forn OR 
           ae-item.data > da-prox-ae-item THEN DO:

            ASSIGN c-msg-erro = "Existe lote com data anterior" + c-anterior
                   p-msg-erro = c-msg-erro.

            RUN trata-erro.

            RUN esp/es0018p.r (INPUT "ESCEP013",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-usuar-quebra).

            FIND FIRST tt-usuar-quebra
                WHERE tt-usuar-quebra.conteudo = p-usuario NO-ERROR.

            IF NOT AVAIL tt-usuar-quebra THEN DO:
                RETURN "NOK".
            END.

        END.

    END.
    ELSE do:
        IF AVAIL ae-item THEN DO:
            /* ae ja baixado */
            ASSIGN c-msg-erro = "AE j† Baixado / Procure respons†vel do Almoxarifado"
                   p-msg-erro = c-msg-erro.
            RUN trata-erro.
            RETURN "NOK".
        END.
        ELSE DO:
            /* inexistente */
            ASSIGN c-msg-erro = "N∆o existe registro desta AE / AE CANCELADA / Procure respons†vel do Almoxarifado" 
                   p-msg-erro = c-msg-erro.
            RUN trata-erro.
            RETURN "NOK".
        END.
    END.

    /* verifica se AE esta bloqueado */    
    FIND ae-bloqueado NO-LOCK 
         where ae-bloqueado.cod-estabel = ae-item.cod-estabel
           and ae-bloqueado.nr-ae     = ae-item.nr-ae
           and ae-bloqueado.sequencia = ae-item.sequencia 
           and ae-bloqueado.it-codigo = c-it-codigo NO-ERROR.
    IF AVAIL ae-bloqueado THEN DO:
        ASSIGN c-msg-erro = "AE BLOQUEADO - Consulte o Respons†vel pelo Almoxarifado"
               p-msg-erro = c-msg-erro.
        RUN trata-erro.
        RETURN "NOK".
    END.
    
    ASSIGN i-nr-linha = 0.

    /*
    RUN esp/es0018p.p (INPUT "ESCEP013RPC", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).    

    for each tt-prog-ponto:
        if num-entries(tt-prog-ponto.conteudo) = 3
        and entry(1, tt-prog-ponto.conteudo) = v_cod_estab_usuar
        AND entry(2, tt-prog-ponto.conteudo) = p-deposito then do:
            i-nr-linha = int(entry(3, tt-prog-ponto.conteudo)).
            leave.
        end.    
    end.        
    */

    FOR FIRST int-lin-prod NO-LOCK
        WHERE int-lin-prod.cod-estabel    = v_cod_estab_usuar
        AND   int-lin-prod.deposito-saida = p-deposito:

        ASSIGN i-nr-linha = int-lin-prod.nr-linha.

    END.
    
    RUN checa-linha.

    IF l-erro THEN DO:
        p-msg-erro = c-msg-erro.
        RETURN "NOK".
    END.

    RETURN "".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

