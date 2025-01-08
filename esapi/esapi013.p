&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttficha-cq NO-UNDO LIKE ficha-cq
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESAPI013
    Purpose     : Atualizar o roteiro, processar as transferàncias de
                  estoque e criar/atualizar os avisos de entrada (AE)
                  para as operaá‰es de transferància entre dep¢sitos
                  Utilizada pelos programas:
                  ESCQP006
    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.
DEFINE BUFFER localizacao FOR mgcad.localizacao.

{include/i-prgvrs.i esapi013 2.04.000.000}

/* ***************************  Definitions  ************************** */
DEF VAR hdbo-ficha-cq AS HANDLE NO-UNDO.

DEFINE VARIABLE h_esapi020 AS HANDLE NO-UNDO.

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

{method/dbotterr.i}
{esp/es0478.i "new"}
{upc/btb910za-upc.i}
{esp/es0478-rpc.i}

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
   Temp-Tables and Buffers:
      TABLE: ttficha-cq T "?" NO-UNDO mgmov ficha-cq
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{esp/eslib.i}
{esapi/esapi013.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    IF NOT VALID-HANDLE(hdbo-ficha-cq) OR
       hdbo-ficha-cq:TYPE <> "PROCEDURE":U OR
       hdbo-ficha-cq:FILE-NAME <> "inbo/boin124a.p":U THEN DO:
       {btb/btb008za.i1 inbo/boin124a.p YES}
       {btb/btb008za.i2 inbo/boin124a.p '' hdbo-ficha-cq}
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAprovaAlm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAprovaAlm Procedure 
PROCEDURE piAprovaAlm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-cod-estab as char no-undo.
    DEF INPUT PARAM TABLE FOR tt-transferencia.
    DEF INPUT PARAM TABLE FOR tt-ae-raw.
    DEF BUFFER b-ae-item FOR ae-item.

    EMPTY TEMP-TABLE tt-ae.
    FOR EACH tt-ae-raw:
        CREATE tt-ae.
        RAW-TRANSFER tt-ae-raw.ae-raw TO tt-ae.
    END.

    FOR FIRST tt-transferencia TRANSACTION:
        i-barra = tt-transferencia.destino.
        EMPTY TEMP-TABLE ttficha-cq.
        RUN emptyRowErrors IN hdbo-ficha-cq NO-ERROR.        
        RUN setConstraintNrFicha IN hdbo-ficha-cq (INPUT tt-transferencia.nr-ficha,
                                                  INPUT tt-transferencia.nr-ficha).
        RUN openQueryStatic IN hdbo-ficha-cq (INPUT "NrFicha":U) NO-ERROR.
        RUN getRecord IN hdbo-ficha-cq (OUTPUT TABLE ttficha-cq).

        FIND FIRST ttficha-cq NO-ERROR.

        IF tt-transferencia.cod-depos-sai = "dev" OR
           tt-transferencia.cod-depos-sai = "tra" THEN DO:

            for each tt-ae
               where tt-ae.c-selecionado,
               FIRST ae-item NO-LOCK
               WHERE ae-item.cod-estabel = pi-cod-estab
               and   ae-item.nr-ae = tt-ae.nr-ae
               AND   ae-item.sequencia = tt-ae.sequencia:

               FIND b-ae-item OF ae-item EXCLUSIVE-LOCK NO-ERROR.

               if tt-ae.qtd-par < ae-item.quantidade then 
                   assign b-ae-item.quantidade = tt-ae.qtd-par.
               else 
                   assign b-ae-item.situacao = yes.
               RELEASE b-ae-item.
            END.
        END.
        RUN piTransfere(input pi-cod-estab,
                        INPUT tt-transferencia.cod-localiz-sai,     /* localizaá∆o de sa°da */
                        input tt-transferencia.quantidade,          /* quantidade total */
                        input tt-transferencia.nr-ficha,            /* numero docto */
                        input "ROT",                                /* serie */
                        input tt-transferencia.nr-ae,               /* numero do AE */
                        input tt-transferencia.sequencia,           /* sequencia do AE */
                        input tt-transferencia.nr-ficha,            /* roteiro */  
                        input int(ttficha-cq.nro-docto),            /* nota */
                        input tt-transferencia.contenedor,          /* contenedor */
                        input ttficha-cq.cod-emitente,              /* fornecedor */
                        INPUT NO,                                   /* usa local informado */
                        input "").                                  /* local destino */

        if l-deu-erro then do:
            undo, RETURN "NOK".
        end.
        RUN piAtualizaFicha.
        IF RETURN-VALUE = "NOK" THEN
            undo, RETURN "NOK".

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaFicha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaFicha Procedure 
PROCEDURE piAtualizaFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST ttficha-cq:
        assign ttficha-cq.qt-aprovada  = tt-transferencia.qt-aprovada
               ttficha-cq.qt-rejeitada = tt-transferencia.qt-rejeitada
               ttficha-cq.qt-apr-cond  = tt-transferencia.qt-apr-cond
               ttficha-cq.narrativa    = tt-transferencia.narrativa
               ttficha-cq.codigo-rejei = tt-transferencia.codigo-rejei.
        RUN setrecord IN hdbo-ficha-cq (INPUT TABLE ttficha-cq).  
        RUN updaterecord IN hdbo-ficha-cq.                        
        RUN getRowErrors IN hdbo-ficha-cq (OUTPUT TABLE RowErrors).
    END.
    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
        FOR FIRST rej-ficha EXCLUSIVE-LOCK
            WHERE rej-ficha.nr-ficha  = tt-transferencia.nr-ficha
            AND   rej-ficha.codigo-rejei = tt-transferencia.codigo-rejei:
            IF LOOKUP(tt-transferencia.cod-depos-sai, "dev,fal,for") > 0 THEN DO:
                assign rej-ficha.qt-rejeitada = rej-ficha.qt-rejeitada - tt-transferencia.quantidade
                       rej-ficha.dec-1        = rej-ficha.dec-1 - tt-transferencia.quantidade.
                if rej-ficha.qt-rejeitada = 0 
                AND rej-ficha.qt-apr-cond  = 0 THEN DELETE rej-ficha.
            END.
        END.
        IF AVAIL rej-ficha THEN RELEASE rej-ficha.

        IF LOOKUP(tt-transferencia.cod-depos-ent, "dev,fal,for") > 0 THEN DO:
            IF NOT CAN-FIND(FIRST rej-ficha NO-LOCK
                        WHERE rej-ficha.nr-ficha  = tt-transferencia.nr-ficha
                        AND   rej-ficha.codigo-rejei = tt-transferencia.codigo-rejei) THEN DO:
                CREATE rej-ficha.
                assign rej-ficha.nr-ficha     = tt-transferencia.nr-ficha
                       rej-ficha.qt-rejeitada = tt-transferencia.quantidade
                       rej-ficha.codigo-rejei = tt-transferencia.codigo-rejei
                       rej-ficha.observacao   = tt-transferencia.observacao.
                       rej-ficha.char-1       = "rej".
            END.
        END.
    END.
    ELSE do:
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
        FOR EACH RowErrors
            WHERE RowErrors.errortype = "error":
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                   tt-erro.mensagem = RowErrors.ErrorDescription.
        END.
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RETURN "NOK".
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piFinaliza) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFinaliza Procedure 
PROCEDURE piFinaliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hdbo-ficha-cq) THEN
        RUN destroy IN hdbo-ficha-cq.
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraAE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraAE Procedure 
PROCEDURE piGeraAE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-cod-estab as char no-undo.
    
    if lookup(tt-transferencia.cod-depos-ent, "dev,alm") > 0 then do:
        FIND first aviso-entrada 
            where aviso-entrada.cod-estabel = pi-cod-estab EXCLUSIVE-LOCK no-error.
        IF AVAIL aviso-entrada THEN
            aviso-entrada.ultimo-ae = aviso-entrada.ultimo-ae + 1.
        ELSE DO:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = pi-cod-estab
                   aviso-entrada.ultimo-ae   = 1.
        END.

        FIND CURRENT aviso-entrada NO-LOCK.

        CREATE ae-item.
        assign ae-item.cod-estabel   = pi-cod-estab
               ae-item.it-codigo     = tt-transferencia.it-codigo
               ae-item.localizacao   = tt-transferencia.cod-localiz-ent
               ae-item.nr-ae         = aviso-entrada.ultimo-ae
               ae-item.sequencia     = 1
               ae-item.quantidade    = tt-transferencia.quantidade
               ae-item.data          = today
               ae-item.roteiro       = tt-transferencia.nr-ficha
               ae-item.nf            = int(ttficha-cq.nro-docto)
               ae-item.data-validade = today
               ae-item.cod-depos     = "dev"
               v_cod_estab_usuar = pi-cod-estab.

        /*
        RUN imprimeAE(INPUT tt-transferencia.impressora,
                      INPUT tt-transferencia.destino,
                      INPUT ae-item.nr-ae,
                      INPUT ae-item.sequencia,
                      INPUT ae-item.sequencia).
        */

        IF NOT valid-handle(h_esapi020) THEN RUN esapi/esapi020.p PERSISTENT SET h_esapi020.

        RUN pi-imprime-AE IN h_esapi020 (INPUT tt-transferencia.impressora,
                                         INPUT ae-item.cod-estabel,
                                         INPUT ae-item.nr-ae,
                                         INPUT ae-item.sequencia,      
                                         INPUT c-seg-usuario).


    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRejeitaAlm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRejeitaAlm Procedure 
PROCEDURE piRejeitaAlm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-cod-estab as char no-undo.
    DEF INPUT PARAM TABLE FOR tt-transferencia.
    DEF INPUT PARAM TABLE FOR tt-ae-raw.
    DEF BUFFER b-ae-item FOR ae-item.

    EMPTY TEMP-TABLE tt-ae.
    FOR EACH tt-ae-raw:
        CREATE tt-ae.
        RAW-TRANSFER tt-ae-raw.ae-raw TO tt-ae.
    END.

    FOR FIRST tt-transferencia TRANSACTION:
        i-barra = tt-transferencia.destino.
        EMPTY TEMP-TABLE ttficha-cq.
        RUN emptyRowErrors IN hdbo-ficha-cq NO-ERROR.        
        RUN setConstraintNrFicha IN hdbo-ficha-cq (INPUT tt-transferencia.nr-ficha,
                                                  INPUT tt-transferencia.nr-ficha).
        RUN openQueryStatic IN hdbo-ficha-cq (INPUT "NrFicha":U) NO-ERROR.
        RUN getRecord IN hdbo-ficha-cq (OUTPUT TABLE ttficha-cq).

        FIND FIRST ttficha-cq NO-ERROR.

        for each tt-ae
           where tt-ae.c-selecionado,
           FIRST ae-item NO-LOCK
           WHERE ae-item.cod-estabel = pi-cod-estab
           and   ae-item.nr-ae = tt-ae.nr-ae
           AND   ae-item.sequencia = tt-ae.sequencia:
           IF congelado(input pi-cod-estab,
                        input tt-transferencia.it-codigo,
                        input tt-transferencia.cod-depos-sai,
                        input ae-item.localizacao) THEN UNDO, RETURN "NOK".

           IF tt-ae.qtd-par >= ae-item.quantidade then DO:
               FIND b-ae-item OF ae-item EXCLUSIVE-LOCK NO-ERROR.
               assign b-ae-item.situacao = yes.
               RELEASE b-ae-item.
           END.

           RUN piTransfere(input pi-cod-estab,
                           INPUT ae-item.localizacao,            /* localizaá∆o de sa°da */
                           input tt-ae.quantidade,               /* quantidade total */
                           input tt-ae.nr-ae,                    /* numero docto */
                           input string(tt-ae.sequencia),        /* serie */
                           input tt-ae.nr-ae,                    /* numero do AE */
                           input tt-ae.sequencia,                /* sequencia do AE */
                           input tt-ae.roteiro,                  /* roteiro */  
                           input 0,                              /* nota */
                           input 0,                              /* contenedor */
                           input tt-ae.cod-emitente,             /* fornecedor */
                           INPUT tt-transferencia.cod-depos-ent = "DEV", /* usa local informado */
                           input if tt-transferencia.cod-depos-ent = "DEV" then tt-transferencia.cod-localiz-ent else "").  
                                                                 /* local destino */
           if l-deu-erro then do:
               undo, RETURN "NOK".
           end.
           /* elimina bloqueio da AE */
           for each ae-bloqueado
              where ae-bloqueado.cod-estabel = pi-cod-estab 
              and ae-bloqueado.nr-ae = tt-ae.nr-ae
              and ae-bloqueado.sequencia = tt-ae.sequencia:
              delete ae-bloqueado.
           end.
        END.

        RUN piAtualizaFicha.
        IF RETURN-VALUE = "NOK" THEN
            undo, RETURN "NOK".
      /*  RUN piGeraAE (INPUT pi-cod-estab). */ /* a piTransfere chama o es0478-n.p, que ja gera a ae */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRejeitaOutros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRejeitaOutros Procedure 
PROCEDURE piRejeitaOutros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pI-cod-estab as char no-undo.
    DEF INPUT PARAM TABLE FOR tt-transferencia.
    DEF INPUT PARAM TABLE FOR tt-ae-raw.

    EMPTY TEMP-TABLE tt-ae.
    FOR EACH tt-ae-raw:
        CREATE tt-ae.
        RAW-TRANSFER tt-ae-raw.ae-raw TO tt-ae.
    END.
    FOR FIRST tt-transferencia TRANSACTION:
        i-barra = tt-transferencia.destino.
        EMPTY TEMP-TABLE ttficha-cq.
        RUN emptyRowErrors IN hdbo-ficha-cq NO-ERROR.        
        RUN setConstraintNrFicha IN hdbo-ficha-cq (INPUT tt-transferencia.nr-ficha,
                                                  INPUT tt-transferencia.nr-ficha).
        RUN openQueryStatic IN hdbo-ficha-cq (INPUT "NrFicha":U) NO-ERROR.
        RUN getRecord IN hdbo-ficha-cq (OUTPUT TABLE ttficha-cq).

        FIND FIRST ttficha-cq NO-ERROR.

        RUN piTransfere(input pi-cod-estab,
                        INPUT tt-transferencia.cod-localiz-sai,       /* localizaá∆o de sa°da */
                        input tt-transferencia.quantidade,            /* quantidade total */
                        input 0,                                      /* numero docto */
                        input "ROT",                                  /* serie */
                        input 0,                                      /* numero do AE */
                        input 0,                                      /* sequencia do AE */
                        input tt-transferencia.nr-ficha,              /* roteiro */  
                        input INT(ttficha-cq.nro-docto),              /* nota */
                        input tt-transferencia.contenedor,            /* contenedor */
                        input ttficha-cq.cod-emitente,                /* fornecedor */
                        INPUT tt-transferencia.cod-depos-ent = "DEV", /* usa local informado */
                        input if tt-transferencia.cod-depos-ent = "DEV" then tt-transferencia.cod-localiz-ent else "").  
                                                                      /* local destino */

        if l-deu-erro then do:
            undo, RETURN "NOK".
        end.
        RUN piAtualizaFicha.
        IF RETURN-VALUE = "NOK" THEN
            undo, RETURN "NOK".
       /* RUN piGeraAE (INPUT pi-cod-estab). */ /* a piTransfere chama o es0478-n.p, que ja gera a ae */

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTransfere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTransfere Procedure 
PROCEDURE piTransfere :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estab as char no-undo.
    DEF INPUT PARAM p-cod-localiz-saida AS CHAR NO-UNDO.
    DEF INPUT PARAM p-quantidade AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-num-docto AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-serie AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nr-ae AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-sequencia AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-nr-ficha AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-nota AS INT NO-UNDO.
    DEF INPUT PARAM p-contenedor AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-cod-emitente AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-usa-local AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-local-dest AS CHAR NO-UNDO.
    DEF VAR c-dispositivo AS CHAR NO-UNDO.

/*     FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock             */
/*         where imprsor_usuar.nom_impressora = tt-transferencia.impressora */
/*         and   imprsor_usuar.cod_usuario    = c-seg-usuario               */
/*         use-index imprsrsr_id:                                           */
/*         c-dispositivo = imprsor_usuar.nom_disposit_so.                   */
/*     END.                                                                 */
    
    l-deu-erro = NO.

    run esp/es0478-n.p (
          input tt-transferencia.it-codigo,     /* item */
          input tt-transferencia.cod-depos-sai, /* deposito de saida */                
          input p-cod-localiz-saida,            /* local de saida */
          input p-quantidade,                   /* quantidade total */
          input tt-transferencia.cod-depos-ent, /* deposito de entrada */
          input p-num-docto,                    /* numero docto */
          input p-serie,                        /* serie */
          input tt-transferencia.narrativa,     /* historico */
          input p-nr-ae,                        /* numero do AE */
          input 0,                              /* sequencia do AE */
          input p-nr-ficha,                     /* roteiro */  
          input p-nota,                         /* nota */
          input no,                             /* baixa parcial */
          input no,                             /* devolucao ou transferencia */
          input p-contenedor,                   /* contenedor */
          input p-cod-emitente,                 /* fornecedor */
          input p-sequencia,                    /* sequencia inicial */
          input p-usa-local,                    /* usa local informado */
          input p-local-dest,                   /* local destino */
          input today,                          /* data movto-estoq */
          input tt-transferencia.dt-validade,   /* Validade da AE */
          input "esapi001," + tt-transferencia.impressora,     /* Campo Caracter livre */
          input p-cod-estab,
          OUTPUT table tt-etiqueta,
          OUTPUT p-msg-erro).
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

