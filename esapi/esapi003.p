&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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

{esapi/esapi003tt.i}
{cdp/cd0666.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnEtiqColetado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEtiqColetado Procedure 
FUNCTION fnEtiqColetado RETURNS CHARACTER
  ( INPUT c-etiqueta AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaCapacidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaCapacidade Procedure 
FUNCTION fnRetornaCapacidade RETURNS INTEGER
  ( INPUT c-etiqueta AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaItem Procedure 
FUNCTION fnRetornaItem RETURNS CHARACTER
  ( INPUT c-item AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaNmUsuar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaNmUsuar Procedure 
FUNCTION fnRetornaNmUsuar RETURNS CHARACTER
  ( INPUT c-usuario AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaQtdeCx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaQtdeCx Procedure 
FUNCTION fnRetornaQtdeCx RETURNS INTEGER
  ( INPUT c-etiq-filho AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaQtdePC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaQtdePC Procedure 
FUNCTION fnRetornaQtdePC RETURNS INTEGER
  ( INPUT c-pallet AS CHARACTER,
    INPUT TABLE FOR tt-ns-volume )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaTipo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaTipo Procedure 
FUNCTION fnRetornaTipo RETURNS CHARACTER
  ( INPUT i-tipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaTpEtiq) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaTpEtiq Procedure 
FUNCTION fnRetornaTpEtiq RETURNS CHARACTER
  ( INPUT c-etiqueta AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piBuscaEtiqColetiva) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiqColetiva Procedure 
PROCEDURE piBuscaEtiqColetiva :
/*------------------------------------------------------------------------------
  Purpose: Busca registro etiq-coletiva de acordo com etiqueta selecionada    
  Notes:   Carlos Daniel - 16/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-etiq-coletiva.

FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiqueta NO-LOCK:

    CREATE tt-etiq-coletiva.
    BUFFER-COPY etiq-coletiva TO tt-etiq-coletiva.

    IF etiq-coletiva.usuario <> "" THEN DO:
        FOR FIRST usuar_mestre FIELDS(nom_usuario)
            WHERE usuar_mestre.cod_usuario = etiq-coletiva.usuario NO-LOCK:

            ASSIGN tt-etiq-coletiva.cnm-usuar = usuar_mestre.nom_usuario.
        END.
    END.

    IF etiq-coletiva.usuar-ult-re <> "" THEN DO:
        FOR FIRST usuar_mestre FIELDS(nom_usuario)
            WHERE usuar_mestre.cod_usuario = etiq-coletiva.usuar-ult-re NO-LOCK:

            ASSIGN tt-etiq-coletiva.cnm-usuar-reimp = usuar_mestre.nom_usuario.
        END.
    END.

    IF etiq-coletiva.usuar-desat <> "" THEN DO:
        FOR FIRST usuar_mestre FIELDS(nom_usuario)
            WHERE usuar_mestre.cod_usuario = etiq-coletiva.usuar-desat NO-LOCK:

            ASSIGN tt-etiq-coletiva.cnm-usuar-desat = usuar_mestre.nom_usuario.
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piBuscaEtiquetaPai) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiquetaPai Procedure 
PROCEDURE piBuscaEtiquetaPai :
/*------------------------------------------------------------------------------
  Purpose: Busca dados da etiqueta coletiva de acordo com o c¢digo informado    
  Notes:   Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER c-etiqueta AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-tipo     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER i-qtde     AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER c-item     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-des-item AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ns-volume.

FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiqueta NO-LOCK:
    
    IF etiq-coletiva.status-etiq = NO THEN DO:
        /*RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Etiqueta inv lida~~Etiqueta foi desativada. Para maiores detalhes, consultar o programa ESCPP014.").
        RETURN "NOK".*/
        RETURN "Etiqueta inv lida~~Etiqueta foi desativada. Para maiores detalhes, consultar o programa ESCPP014.".
    END.

    ASSIGN c-tipo     = fnRetornaTipo(etiq-coletiva.tipo)
           i-qtde     = etiq-coletiva.quantidade
           c-item     = etiq-coletiva.it-codigo
           c-des-item = fnRetornaItem(etiq-coletiva.it-codigo).
END.

IF NOT AVAIL etiq-coletiva THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv lida~~Certifique-se de que a etiqueta lida pertence a um dos tipos v lidos: Caixa, Pallet.").
    RETURN "NOK".*/
    RETURN "Etiqueta inv lida~~Certifique-se de que a etiqueta lida pertence a um dos tipos v lidos: Caixa, Pallet.".
END.

EMPTY TEMP-TABLE tt-ns-volume.

/*busca ns vinculadas a etiqueta*/
FOR EACH ns-volume
    WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK:
    
    CREATE tt-ns-volume.
    BUFFER-COPY ns-volume TO tt-ns-volume.
    ASSIGN tt-ns-volume.tipo       = fnRetornaTpEtiq(tt-ns-volume.volume-filho)
           tt-ns-volume.nome-usuar = fnRetornaNmUsuar(tt-ns-volume.usuario).
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piBuscaEtiqVinculo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiqVinculo Procedure 
PROCEDURE piBuscaEtiqVinculo :
/*------------------------------------------------------------------------------
  Purpose: Busca dados da etiqueta coletiva de acordo com o c¢digo informado    
  Notes:   Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER c-etiqueta AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-tipo     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER i-qtde     AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER c-item     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-des-item AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-status   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-etiqueta.

DEFINE BUFFER bf-ns-volume FOR ns-volume.

DEFINE VARIABLE l-possui-cx AS LOGICAL     NO-UNDO.


FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiqueta NO-LOCK:

    ASSIGN c-tipo     = fnRetornaTipo(etiq-coletiva.tipo)
           i-qtde     = etiq-coletiva.quantidade
           c-item     = etiq-coletiva.it-codigo
           c-des-item = fnRetornaItem(etiq-coletiva.it-codigo)
           c-status   = IF etiq-coletiva.status-etiq THEN "ATIVO" ELSE "INATIVO".
END.

IF NOT AVAIL etiq-coletiva THEN DO:
    FOR FIRST num-serie
        WHERE num-serie.n-serie = c-etiqueta NO-LOCK:

        ASSIGN c-tipo     = "NS"
               i-qtde     = 1
               c-item     = num-serie.it-codigo
               c-des-item = fnRetornaItem(num-serie.it-codigo)
               c-status   = "ATIVO".
    END.

    IF NOT AVAIL num-serie THEN DO:
        /*RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Etiqueta inv lida~~Certifique-se de que a etiqueta lida pertence a um dos tipos v lidos: Caixa, Pallet ou Produto.").
        RETURN "NOK".*/
        RETURN "Etiqueta inv lida~~Certifique-se de que a etiqueta lida pertence a um dos tipos v lidos: Caixa, Pallet ou Produto.".
    END.
END.


ASSIGN l-possui-cx = NO.    


EMPTY TEMP-TABLE tt-etiqueta.

CASE c-tipo:
    WHEN "PALLET" THEN DO:
        /*busca ns vinculadas a etiqueta*/
        FOR EACH ns-volume
            WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK:
            
            FOR FIRST num-serie
                WHERE num-serie.n-serie = ns-volume.volume-filho NO-LOCK:

                CREATE tt-etiqueta.
                ASSIGN tt-etiqueta.cod-pallet  = ns-volume.volume-pai
                       tt-etiqueta.cod-caixa   = ""
                       tt-etiqueta.cod-produto = ns-volume.volume-filho
                       tt-etiqueta.data        = ns-volume.data
                       tt-etiqueta.nom-usuar   = fnRetornaNmUsuar(ns-volume.usuario).
            END.

            IF NOT AVAIL num-serie THEN DO:
                FOR EACH bf-ns-volume
                    WHERE bf-ns-volume.volume-pai = ns-volume.volume-filho NO-LOCK:
                
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.cod-pallet  = ns-volume.volume-pai
                           tt-etiqueta.cod-caixa   = ns-volume.volume-filho
                           tt-etiqueta.cod-produto = bf-ns-volume.volume-filho
                           tt-etiqueta.data        = bf-ns-volume.data
                           tt-etiqueta.nom-usuar   = fnRetornaNmUsuar(bf-ns-volume.usuario).
                END.
            END.
        END.
    END.
    WHEN "CAIXA" THEN DO:
        FOR EACH ns-volume
            WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK:
            
            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.cod-caixa   = ns-volume.volume-pai
                   tt-etiqueta.cod-produto = ns-volume.volume-filho
                   tt-etiqueta.data        = ns-volume.data
                   tt-etiqueta.nom-usuar   = fnRetornaNmUsuar(ns-volume.usuario).

            FOR FIRST bf-ns-volume
                WHERE bf-ns-volume.volume-filho = ns-volume.volume-pai NO-LOCK:

                ASSIGN tt-etiqueta.cod-pallet = bf-ns-volume.volume-pai.
            END.
        END.
    END.
    WHEN "NS" THEN DO:
        FOR FIRST ns-volume
            WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK:

            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.cod-caixa   = ns-volume.volume-pai
                   tt-etiqueta.cod-produto = ns-volume.volume-filho
                   tt-etiqueta.data        = ns-volume.data
                   tt-etiqueta.nom-usuar   = fnRetornaNmUsuar(ns-volume.usuario).

            FOR FIRST bf-ns-volume
                WHERE bf-ns-volume.volume-filho = ns-volume.volume-pai NO-LOCK:

                ASSIGN tt-etiqueta.cod-pallet = bf-ns-volume.volume-pai
                       l-possui-cx            = YES.
            END.

            IF NOT l-possui-cx THEN
                ASSIGN tt-etiqueta.cod-pallet  = ns-volume.volume-pai
                       tt-etiqueta.cod-caixa   = "".
        END.
    END.
END CASE.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piExcluiVolume) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiVolume Procedure 
PROCEDURE piExcluiVolume :
/*------------------------------------------------------------------------------
  Purpose: Inativa etiqueta na etiq-coletiva e elimina ns-volume (pai/filho)
  Notes:   Carlos Daniel - 10/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta AS CHARACTER NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiqueta EXCLUSIVE-LOCK:

    ASSIGN etiq-coletiva.status-etiq = NO
           etiq-coletiva.dt-desat    = NOW
           etiq-coletiva.usuar-desat = c-seg-usuario.
END.

IF NOT AVAIL etiq-coletiva THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv lida~~Etiqueta inexistente ou inativa, favor verificar.").
    RETURN "NOK".*/
    RETURN "Etiqueta inv lida~~Etiqueta inexistente ou inativa, favor verificar.".
END.

FOR EACH ns-volume
    WHERE ns-volume.volume-pai = c-etiqueta EXCLUSIVE-LOCK:

    DELETE ns-volume.
END.

IF etiq-coletiva.tipo = 1 THEN DO: /*Caixa*/
    FOR EACH ns-volume
        WHERE ns-volume.volume-filho = c-etiqueta EXCLUSIVE-LOCK:

        DELETE ns-volume.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraErro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraErro Procedure 
PROCEDURE piGeraErro :
/*------------------------------------------------------------------------------
  Purpose: Gera temp-table de erro    
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pCdErro AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pmsg AS CHARACTER   NO-UNDO.

CREATE tt-erro.
ASSIGN tt-erro.cd-erro = pCdErro
       tt-erro.mensagem = pMsg.
       
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGravaVolume) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaVolume Procedure 
PROCEDURE piGravaVolume :
/*------------------------------------------------------------------------------
  Purpose: Grava registros da tt-ns-volume na tabela ns-volume    
  Notes:   Carlos Daniel - 10/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-ns-volume.

FOR EACH tt-ns-volume:
    IF NOT CAN-FIND(FIRST ns-volume
                    WHERE ns-volume.volume-pai   = tt-ns-volume.volume-pai
                    AND   ns-volume.sequencia    = tt-ns-volume.sequencia
                    AND   ns-volume.volume-filho = tt-ns-volume.volume-filho) THEN DO:
        CREATE ns-volume.
        BUFFER-COPY tt-ns-volume TO ns-volume.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidaEtiqueta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEtiqueta Procedure 
PROCEDURE piValidaEtiqueta :
/*------------------------------------------------------------------------------
  Purpose: Realiza valida‡äes da etiqueta filho lida    
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiq-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiq-filho AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l-valida-cx  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

EMPTY TEMP-TABLE tt-erro.

DEFINE VARIABLE c-aux AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-etiq-coletiva FOR etiq-coletiva.

FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiq-pai NO-LOCK:

    IF NOT etiq-coletiva.status-etiq THEN
        RETURN "Etiqueta inv lida~~A etiqueta nÆo est  ativa.".

    IF etiq-coletiva.tipo = 1 THEN DO: /*Caixa*/
        RUN piValidaNS(INPUT c-etiq-filho).
        IF RETURN-VALUE <> "OK" THEN
            RETURN RETURN-VALUE.
    END.
    ELSE IF etiq-coletiva.tipo = 2 THEN DO: /*Pallet*/

        IF CAN-FIND(FIRST num-serie
                    WHERE num-serie.n-serie = c-etiq-filho) THEN DO:
            RUN piValidaNS(INPUT c-etiq-filho).
            IF RETURN-VALUE <> "OK" THEN
            RETURN RETURN-VALUE.
        END.
        ELSE DO:
            FOR FIRST bf-etiq-coletiva
                WHERE bf-etiq-coletiva.cod-etiqueta = c-etiq-filho NO-LOCK:
                
                IF NOT bf-etiq-coletiva.status-etiq THEN
                    RETURN "Etiqueta inv lida~~A etiqueta nÆo est  ativa.".
                    /*RUN piGeraErro(INPUT 17006,
                                   INPUT "Etiqueta inv lida~~A etiqueta nÆo est  ativa.").*/

                IF bf-etiq-coletiva.it-codigo <> etiq-coletiva.it-codigo THEN
                    RETURN "Etiqueta com item inv lido~~O item lido ‚ diferente do item cadastrado para a embalagem, favor verificar.".
                    /*RUN piGeraErro(INPUT 17006,
                                   INPUT "Etiqueta com item inv lido~~O item lido ‚ diferente do item cadastrado para a embalagem, favor verificar.").*/

                IF l-valida-cx THEN DO:
                    IF fnRetornaQtdeCx(bf-etiq-coletiva.cod-etiqueta) <> bf-etiq-coletiva.quantidade THEN
                        RETURN "Caixa incompleta~~A caixa nÆo possui todos os n£meros de s‚ries coletados.".
                        /*RUN piGeraErro(INPUT 17006,
                                       INPUT "Caixa incompleta~~A caixa nÆo possui todos os n£meros de s‚ries coletados.").*/
                END.
                ASSIGN c-aux = fnEtiqColetado(c-etiq-filho).
                IF c-aux <> "" THEN
                    RETURN "Caixa j  coletada~~A caixa foi coletada para o pallet " + c-aux + ".".
                    /*RUN piGeraErro(INPUT 17006,
                                   INPUT "Caixa j  coletada~~A caixa foi coletada para o pallet " + c-aux + ".").*/
            END.
            
            IF NOT AVAIL bf-etiq-coletiva THEN
                RETURN "Etiqueta inv lida~~A etiqueta deve ser de Caixa ou NS. Favor verificar.".
        END.
    END.
END.

IF NOT AVAIL etiq-coletiva THEN
    RETURN "Etiqueta inv lida~~O C¢digo da Etiqueta informada nÆo existe.".
    /*RUN piGeraErro(INPUT 17006,
                   INPUT "Etiqueta inv lida~~O C¢digo da Etiqueta informada nÆo existe.").*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidaNS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaNS Procedure 
PROCEDURE piValidaNS :
/*------------------------------------------------------------------------------
  Purpose: Valida‡äes referentes a etiqueta de n£mero de s‚rie     
  Notes:   Carlos Daniel - 05/05/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiq-filho AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-aux AS CHARACTER NO-UNDO.

FOR FIRST num-serie
    WHERE num-serie.n-serie = c-etiq-filho NO-LOCK:

    IF etiq-coletiva.it-codigo <> num-serie.it-codigo THEN
        RETURN "Etiqueta com item inv lido~~O item lido ‚ diferente do item cadastrado para a embalagem, favor verificar.".
        /*RUN piGeraErro(INPUT 17006,
                       INPUT "Etiqueta com item inv lido~~O item lido ‚ diferente do item cadastrado para a embalagem, favor verificar.").*/

    ASSIGN c-aux = fnEtiqColetado(c-etiq-filho).
    IF c-aux <> "" THEN
        RETURN "N£mero de S‚rie j  coletado~~O n£mero de s‚rie foi coletado para a caixa " + c-aux + ".".
        /*RUN piGeraErro(INPUT 17006,
                       INPUT "N£mero de S‚rie j  coletado~~O n£mero de s‚rie foi coletado para a caixa " + c-aux + ".").*/
END.

IF NOT AVAIL num-serie THEN
    RETURN "Etiqueta nÆo ‚ de n£mero de s‚rie~~Para caixa, ‚ permitido apenas leitura de etiquetas de n£mero de s‚rie.".
    /*RUN piGeraErro(INPUT 17006,
                   INPUT "Etiqueta nÆo ‚ de n£mero de s‚rie~~Para caixa, ‚ permitido apenas leitura de etiquetas de n£mero de s‚rie.").*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnEtiqColetado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEtiqColetado Procedure 
FUNCTION fnEtiqColetado RETURNS CHARACTER
  ( INPUT c-etiqueta AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Verifica se etiqueta j  foi coletada
    Notes: Carlos Daniel - 05/02/2016
------------------------------------------------------------------------------*/
DEFINE BUFFER bf-ns-volume FOR ns-volume.

FOR FIRST bf-ns-volume
    WHERE bf-ns-volume.volume-filho = c-etiqueta NO-LOCK:

    RETURN bf-ns-volume.volume-pai.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaCapacidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaCapacidade Procedure 
FUNCTION fnRetornaCapacidade RETURNS INTEGER
  ( INPUT c-etiqueta AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna capacidade da etiqueta informada
    Notes: Carlos Daniel - 06/05/2016
------------------------------------------------------------------------------*/
FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta = c-etiqueta NO-LOCK:

    RETURN etiq-coletiva.quantidade.
END.

RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaItem Procedure 
FUNCTION fnRetornaItem RETURNS CHARACTER
  ( INPUT c-item AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna descri‡Æo do item 
    Notes: Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
FOR FIRST item FIELDS(desc-item)
    WHERE item.it-codigo = c-item NO-LOCK:

    RETURN item.desc-item.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaNmUsuar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaNmUsuar Procedure 
FUNCTION fnRetornaNmUsuar RETURNS CHARACTER
  ( INPUT c-usuario AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna nome completo do usu rio
    Notes: Carlos Daniel - 02/03/2016
------------------------------------------------------------------------------*/
FOR FIRST usuar_mestre FIELDS(nom_usuario)
    WHERE usuar_mestre.cod_usuario = c-usuario NO-LOCK:

    RETURN usuar_mestre.nom_usuario.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaQtdeCx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaQtdeCx Procedure 
FUNCTION fnRetornaQtdeCx RETURNS INTEGER
  ( INPUT c-etiq-filho AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna a quantidade de itens coletados da etiqueta lida 
    Notes: Carlos Daniel - 05/02/2016
------------------------------------------------------------------------------*/
DEFINE BUFFER bf-ns-volume FOR ns-volume.

FOR EACH bf-ns-volume
    WHERE bf-ns-volume.volume-pai = c-etiq-filho NO-LOCK:
    ACCUMULATE bf-ns-volume.volume-pai (COUNT).
END.

RETURN ACCUM COUNT bf-ns-volume.volume-pai.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaQtdePC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaQtdePC Procedure 
FUNCTION fnRetornaQtdePC RETURNS INTEGER
  ( INPUT c-pallet AS CHARACTER,
    INPUT TABLE FOR tt-ns-volume ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna a quantidade de pe‡as vinculadas as caixas do pallet 
    Notes: Carlos Daniel - 04/05/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-cont   AS INTEGER   NO-UNDO.

DEFINE BUFFER bf-ns-volume    FOR ns-volume.
DEFINE BUFFER bf-ns-volume-pl FOR ns-volume.

/*contagem para novos produtos/caixas sendo vinculados*/
FOR EACH tt-ns-volume:
    /*Se volume filho for produto*/
    FOR FIRST num-serie
        WHERE num-serie.n-serie = tt-ns-volume.volume-filho NO-LOCK:

        ASSIGN i-cont = i-cont + 1.
    END.

    /*Se volume filho for caixa*/
    IF NOT AVAIL num-serie THEN DO:
        FOR EACH bf-ns-volume
            WHERE bf-ns-volume.volume-pai = tt-ns-volume.volume-filho NO-LOCK:

            ASSIGN i-cont = i-cont + 1.
        END.
    END.
END.

/*Contagem caso pallet j  tenha outras caixas/produtos vinculados*/
FOR EACH bf-ns-volume
    WHERE bf-ns-volume.volume-pai = c-pallet NO-LOCK:

    IF NOT CAN-FIND(FIRST tt-ns-volume
                    WHERE tt-ns-volume.volume-pai   = c-pallet
                    AND   tt-ns-volume.volume-filho = bf-ns-volume.volume-filho) THEN DO:

        FOR FIRST num-serie
            WHERE num-serie.n-serie = bf-ns-volume.volume-filho NO-LOCK:

            ASSIGN i-cont = i-cont + 1.
        END.

        IF NOT AVAIL num-serie THEN DO:
            FOR EACH bf-ns-volume-pl
                WHERE bf-ns-volume-pl.volume-pai = bf-ns-volume.volume-filho NO-LOCK:

                ASSIGN i-cont = i-cont + 1.
            END.
        END.
    END.
END.

RETURN i-cont.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaTipo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaTipo Procedure 
FUNCTION fnRetornaTipo RETURNS CHARACTER
  ( INPUT i-tipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna tipo da etiqueta 
    Notes: Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
CASE i-tipo:
    WHEN 1 THEN RETURN "CAIXA".
    WHEN 2 THEN RETURN "PALLET".
    OTHERWISE   RETURN "".
END CASE.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnRetornaTpEtiq) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaTpEtiq Procedure 
FUNCTION fnRetornaTpEtiq RETURNS CHARACTER
  ( INPUT c-etiqueta AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna tipo da etiqueta: Caixa, pallet ou NS
    Notes: Carlos Daniel - 11/02/2016
------------------------------------------------------------------------------*/
DEFINE BUFFER bf-fn-etiq-coletiva FOR etiq-coletiva.

IF CAN-FIND(FIRST num-serie
            WHERE num-serie.n-serie = c-etiqueta) THEN
    RETURN "NS".
ELSE DO:
    FOR FIRST bf-fn-etiq-coletiva
        WHERE bf-fn-etiq-coletiva.cod-etiqueta = c-etiqueta NO-LOCK:

        RETURN fnRetornaTipo(bf-fn-etiq-coletiva.tipo).
    END.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

