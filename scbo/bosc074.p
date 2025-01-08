&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i BOSC074 2.00.00.043 } /*** "010043" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bosc074 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOSC074
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName wm-etiqueta
&GLOBAL-DEFINE TableLabel wm-etiqueta
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{scbo/bosc074.i RowObject}
{scbo/bosc074.i ttWm-NaoAgrupador}
{cdp/cdcfgmat.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{cdp/cdcfgwms.i}
{utp/ut-glob.i}
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
/*** Definicao EPC ***/
{include/i-epc200.i bosc074}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}   FOR {&TableName}.
DEFINE BUFFER b-wm-etiqueta    FOR {&TableName}.
DEFINE BUFFER b-wm-docto-itens FOR wm-docto-itens.
DEFINE NEW GLOBAL SHARED VAR l-ckd          as LOG INITIAL NO no-undo.

DEF VAR hDBOWm-param AS HANDLE NO-UNDO.
DEF VAR hDBOWm-carga AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOsc044 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOsc058 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOsc047 AS HANDLE      NO-UNDO.

DEF TEMP-TABLE ttSerial NO-UNDO
        FIELD de-serial AS DECIMAL.
        
DEFINE TEMP-TABLE tt-etiq-consulta NO-UNDO
    FIELD num-docto                  LIKE wm-docto.num-docto
    FIELD cod-estabel                LIKE wm-docto.cod-estabel
    FIELD cod-local                  LIKE wm-docto.cod-local
    FIELD c-ind-origem-docto         AS CHARACTER Format 'x(14)':U. 
        
DEF TEMP-TABLE ttSerialAux NO-UNDO
        FIELD de-serial AS DECIMAL.

DEF TEMP-TABLE ttSerialQtd NO-UNDO
        FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
        FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado.

DEFINE TEMP-TABLE tt-serial-picking NO-UNDO
       FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
       FIELD id-movto             LIKE wm-movto.id-movto
       INDEX idx-serial  AS PRIMARY UNIQUE
             id-etiqueta.

DEF TEMP-TABLE ttWm-Etiqueta       NO-UNDO LIKE wm-etiqueta.
DEF TEMP-TABLE ttWm-Etiqueta2      NO-UNDO LIKE RowObject.
DEF TEMP-TABLE ttWm-BloqueioSerial NO-UNDO LIKE RowObject.
DEF TEMP-TABLE tt-impressao-etiq   NO-UNDO LIKE RowObject.

DEF TEMP-TABLE ttWm-etiqueta-aux   NO-UNDO LIKE wm-etiqueta.
DEF TEMP-TABLE ttwm-box-saldo-aux  NO-UNDO LIKE wm-box-saldo.

DEFINE TEMP-TABLE tt-etiqueta-wms NO-UNDO
    FIELD id-etiqueta   LIKE wm-etiqueta.id-etiqueta
    FIELD cod-embalagem LIKE wm-embalagem.cod-embalagem
    FIELD cod-layout    AS   INTEGER. /*C¬¢digo da etiqueta de layout*/

def temp-table tt-etiqueta no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    index codigo is unique id-etiqueta.


DEF TEMP-TABLE tt-embalagem NO-UNDO
    FIELD CodItem            AS CHARACTER FORMAT "X(16)":U
    FIELD CodRefer           AS CHARACTER FORMAT "X(8)":U
    FIELD CodLote            AS CHARACTER FORMAT "X(40)":U
    FIELD DtValidadeLote     AS DATE      
    FIELD NumSeqItem         AS INTEGER 
    FIELD CodEmbalagem       AS CHARACTER FORMAT "X(010)":U
    FIELD cod-emb-pai        AS CHARACTER FORMAT "X(010)":U
    FIELD logPai             AS LOGICAL
    FIELD ControlaEtiqueta   AS LOGICAL
    FIELD QtdItemEmbalagem   AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD QtdEmbalagem       AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD QtdItem            AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD CodLayoutItem      AS INTEGER   FORMAT "9999":U
    FIELD CodLayoutEmbalagem AS INTEGER   FORMAT "9999":U
    FIELD CodBarrasItem      AS CHARACTER FORMAT "X(100)":U
    FIELD CodBarrasEmbalagem AS CHARACTER FORMAT "X(100)":U
    FIELD id-movto           AS DECIMAL FORMAT ">>>>>>>>>9".

DEF TEMP-TABLE tt-mensagem NO-UNDO
    FIELD mensagem AS CHAR format "x(75)" extent 5
    FIELD char-1   AS CHAR format "x(255)"
    FIELD dec-1    AS DEC
    FIELD log-1    AS LOG
    FIELD int-1    AS INT.
    
DEF TEMP-TABLE ttWm-Etiqueta-Number NO-UNDO
    FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
    FIELD dec-1    AS DEC
    FIELD log-1    AS LOG
    FIELD int-1    AS INT.    
    
DEFINE TEMP-TABLE tt-imp-etiqueta NO-UNDO
       FIELD cod-item         LIKE wm-etiqueta.cod-item
       FIELD cod-refer        LIKE wm-etiqueta.cod-refer
       FIELD cod-lote         LIKE wm-etiqueta.cod-lote
       FIELD cod-embalagem    LIKE wm-etiqueta.cod-embalagem
       FIELD cod-emb-item     LIKE wm-etiqueta.cod-embalagem
       FIELD dt-validade-lote LIKE wm-etiqueta.dt-validade-lote
       FIELD tot-qt-caixa     AS INTEGER FORMAT ">>>>>9" COLUMN-LABEL "Tot Qt Caixas"
       FIELD tot-qt-pallet    AS INTEGER FORMAT ">>>>>9" COLUMN-LABEL "Tot Qt Pallets"
       FIELD qt-cx-pallet     AS INTEGER FORMAT ">>>>>9" COLUMN-LABEL "Qt Cx Pallet"
       FIELD qt-it-cx         AS INTEGER FORMAT ">>>>>9" COLUMN-LABEL "Qt Item Cx"
       FIELD qt-peso-cx       LIKE wm-etiqueta.qtd-peso
       FIELD l-imprime        AS LOGICAL INITIAL YES COLUMN-LABEL "Imprime?".

DEF VAR i-id-carga    LIKE wm-carga.id-carga       NO-UNDO.
DEF VAR i-id-etiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

DEF VAR i-id-etiqueta-ini LIKE wm-etiqueta.id-etiqueta INIT 0  NO-UNDO.
DEF VAR i-id-etiqueta-fim LIKE wm-etiqueta.id-etiqueta INIT 99999999999999 NO-UNDO.
DEF VAR c-cod-estabel     LIKE Wm-etiqueta.cod-estabel         NO-UNDO.
DEF VAR c-cod-estabel-ord LIKE Wm-etiqueta.cod-estabel-ord     NO-UNDO.
DEF VAR i-nr-ord-prod     LIKE Wm-etiqueta.nr-ord-prod         NO-UNDO.
DEF VAR c-cod-item        LIKE Wm-etiqueta.cod-item            NO-UNDO.
DEF VAR c-cod-refer       LIKE Wm-etiqueta.cod-refer           NO-UNDO.
DEF VAR c-cod-lote        LIKE Wm-etiqueta.cod-lote            NO-UNDO.

DEF VAR i-nao-agrupa          AS INTEGER NO-UNDO.
DEF VAR i-agrupador           AS INTEGER NO-UNDO.
DEF VAR i-proprio             AS INTEGER NO-UNDO.
DEF VAR l-inf-carga           AS LOGICAL NO-UNDO.
DEF VAR de-id-carga           LIKE Wm-etiqueta.id-carga NO-UNDO.
DEF VAR l-log-efetua-packing  AS LOGICAL NO-UNDO.

DEFINE VARIABLE l-encontrou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-qtd-emb    AS INTEGER     NO-UNDO.

DEFINE BUFFER     bfwm-box-movto       FOR Wm-box-movto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 20.08
         WIDTH              = 39.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */
DEF TEMP-TABLE ttRowErrors NO-UNDO LIKE RowErrors.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF '{&mgscm_version}' >= '2.07' &THEN
        IF  RowObject.dat-ult-contag = ? THEN
            ASSIGN RowObject.dat-ult-contag = TODAY.
    &ELSE
        IF  RowObject.data-1 = ? THEN
            ASSIGN RowObject.data-1 = TODAY.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF '{&mgscm_version}' >= '2.07' &THEN
        
        FIND FIRST wm-box-saldo-etiqueta
             WHERE wm-box-saldo-etiqueta.id-etiqueta = RowObject.id-etiqueta NO-LOCK NO-ERROR.
            
            IF AVAIL wm-box-saldo-etiqueta THEN DO:
                
                find first wm-box-saldo
                    where wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel 
                      AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local 
                      and wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo exclusive-lock no-error.
                
                IF AVAIL wm-box-saldo THEN
                    &IF '{&mgscm_version}' >= '2.06B' &THEN
                        &IF '{&mgscm_version}' >= '2.07' &THEN
                            ASSIGN wm-box-saldo.dat-ult-contag = RowObject.dat-ult-contag.
                        &ELSE
                            ASSIGN wm-box-saldo.data-1 = RowObject.data-1.    
                        &endif
                    &ENDIF
            END.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE associaAgrupCarga DBOProgram 
PROCEDURE associaAgrupCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    
  O mÇtodo consiste em  associar um agrupador a uma carga. S¢ ser† poss°vel a 
  associaá∆o de uma etiqueta agrupadora, que j† tenha sido reportada e que n∆o 
  esteja associada a nenhuma outra carga. Todas as etiquetas n∆o-agrupadoras 
  pertencentes Ö etiqueta agrupadora ser∆o atualizadas com o usu†rio e o id-carga.
    
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pCodUsuario AS CHARACTER.
    DEF INPUT PARAM pSerialAgrup AS DECIMAL.
    DEF INPUT PARAM pSerialCarga AS DECIMAL.
    
    DEF VAR c-agrupador AS CHAR NO-UNDO.
    
    ASSIGN c-agrupador = STRING(pSerialAgrup).

    IF NOT VALID-HANDLE(hDBOWm-carga) THEN
        RUN scbo/bosc075.p PERSISTENT SET hDBOWm-carga.
    
    FIND FIRST usuario-scm WHERE
        usuario-scm.usuario = pCodUsuario NO-LOCK NO-ERROR.
        
    IF NOT AVAIL usuario-scm THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-usuario"}
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF NOT usuario-scm.log-utiliza-coletor THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26068"
                &ErrorType="EMS"
                &ErrorParameters="pCodUsuario"}

            RETURN "NOK":U.
        END.
    END.
    
    RUN validaCargaAssociar IN hDBOWm-carga(INPUT pSerialCarga).   
        
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-carga (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-carga.
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerialAgrup 
        EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta"}
        RUN DESTROY IN hDBOWm-carga.    
        RETURN "NOK":U.
    END.
    
    /*******************************************************************
    ** Consistencia que verifica se alguma Etiqueta Nao Agrupa (Item) **
    ** do pallet ao qual deseja-se associar a carga, esta relacionada **
    ** a uma outra carga.                                             **
    *******************************************************************/
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:
        FIND FIRST b-wm-etiqueta
             WHERE b-wm-etiqueta.id-agrupador = wm-etiqueta.id-etiqueta AND
                   b-wm-etiqueta.id-carga    <> 0                       AND
                   b-wm-etiqueta.id-carga    <> pSerialCarga            NO-LOCK NO-ERROR.

        IF AVAIL b-wm-etiqueta THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="28408"
                &ErrorType="EMS"
                &ErrorParameters="STRING(b-wm-etiqueta.id-etiqueta) + '~~~~' + STRING(b-wm-etiqueta.id-carga) + '~~~~' + STRING(wm-etiqueta.id-etiqueta)"}

            RELEASE wm-etiqueta.
            RUN DESTROY IN hDBOWm-carga.
            RETURN "NOK":U.
        END.
    END.
    
    IF wm-etiqueta.id-carga <> 0  THEN DO:  /* J† associado a uma carga */
        {method/svc/errors/inserr.i
            &ErrorNumber="26011"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.    
        RUN DESTROY IN hDBOWm-carga.
        RETURN "NOK":U.
    END.
 

    IF NOT wm-etiqueta.log-reportada THEN DO:  /* N∆o reportada Ö produá∆o */
        {method/svc/errors/inserr.i
            &ErrorNumber="26086"
            &ErrorType="EMS"
            &ErrorParameters="c-agrupador"}
        RELEASE wm-etiqueta.
        RUN DESTROY IN hDBOWm-carga.
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /* Agrupador de Etiquetas */

        /* Atualiza as etiquetas de itens  */
        FOR EACH bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 WHERE
            bf{&tablename}.ind-sit-agrupador = 1 AND   /* N∆o agrupa */
            bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta 
            EXCLUSIVE-LOCK:
            
            ASSIGN bf{&tablename}.id-carga               = pSerialCarga
                /* bf{&TableName}.cod-usuario            = pCodUsuario. */
                   bf{&TableName}.cod-usuario-ult-acesso = pCodUsuario
                   bf{&TableName}.dt-ult-acesso          = TODAY
                   bf{&TableName}.hr-ult-acesso          = TIME.
            
        END.
    END.
            
    ASSIGN wm-etiqueta.id-carga               = pSerialCarga
           wm-etiqueta.ind-leitura-etiqueta   = 2      /* Lida  */
        /* wm-etiqueta.cod-usuario            = pCodUsuario. */
           wm-etiqueta.cod-usuario-ult-acesso = pCodUsuario
           wm-etiqueta.dt-ult-acesso          = TODAY
           wm-etiqueta.hr-ult-acesso          = TIME.
    
/*    IF l-ckd THEN 
       ASSIGN wm-etiqueta.id-agrupador = wm-etiqueta.id-carga.*/

    RELEASE wm-etiqueta.
    
    RUN DESTROY IN hDBOWm-carga.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE associaEtiquetas DBOProgram 
PROCEDURE associaEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       


------------------------------------------------------------------------------*/

    DEF INPUT PARAM pCodUsuario AS CHARACTER.
    DEF INPUT PARAM TABLE FOR ttSerial.          /* Temp-tables com os seriais dos itens gerados para serem agrupados  */
    DEF INPUT PARAM pSerialAgrup AS DECIMAL.     /* Serial do Agrupador   */


    FIND FIRST ttSerial NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttSerial THEN RETURN "NOK".
        
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerialAgrup 
        NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-2"}
    
        RETURN "NOK":U.
    END.
    IF wm-etiqueta.ind-sit-agrupador <> 2  THEN DO:  /* AGRUPA ITEM */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-do-agrupador AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta_do_agrupador" *}
        ASSIGN c-lbl-liter-etiqueta-do-agrupador = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-do-agrupador"}
        RELEASE wm-etiqueta.
        RETURN "NOK":U.
    END.
    

    FOR EACH ttSerial:
        
        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial 
            EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL wm-etiqueta THEN RETURN "NOK":U.
        
        ASSIGN wm-etiqueta.id-agrupador = pSerialAgrup
               wm-etiqueta.cod-usuario  = pCodUsuario.
    
        RELEASE wm-etiqueta.
        
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE associaNovaCarga DBOProgram 
PROCEDURE associaNovaCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pSerialAgrup    AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pSerialCarga    AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pSerialCargaOld AS DECIMAL NO-UNDO.
    
    FIND FIRST wm-carga 
         WHERE wm-carga.id-carga = pSerialCarga NO-LOCK NO-ERROR.
        
    IF NOT AVAIL wm-carga THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-carga AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Carga" *}
        ASSIGN c-lbl-liter-carga = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-carga"}
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-etiqueta 
         WHERE wm-etiqueta.id-etiqueta = pSerialAgrup NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-3"}
        RETURN "NOK":U.
    END.
    
    ASSIGN pSerialCargaOld = wm-etiqueta.id-carga. 
    
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /** Agrupador de Etiquetas **/
       
        /*******************************************************************
        ** Consistencia que verifica se alguma Etiqueta Nao Agrupa (Item) **
        ** do pallet ao qual deseja-se alterar a carga, esta relacionada  **
        ** a uma outra carga.                                             **
        *******************************************************************/
        FIND FIRST b-wm-etiqueta
             WHERE b-wm-etiqueta.id-agrupador = wm-etiqueta.id-etiqueta AND
                   b-wm-etiqueta.id-carga    <> 0                       AND
                   b-wm-etiqueta.id-carga    <> pSerialCargaOld         NO-LOCK NO-ERROR.

        IF AVAIL b-wm-etiqueta THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="28408"
                &ErrorType="EMS"
                &ErrorParameters="STRING(b-wm-etiqueta.id-etiqueta) + '~~~~' + STRING(b-wm-etiqueta.id-carga) + '~~~~' + STRING(wm-etiqueta.id-etiqueta)"}
            RETURN "NOK":U.
        END.
    
        /** Atualiza as Etiquetas de Itens **/
        FOR EACH  bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 
            WHERE bf{&tablename}.ind-sit-agrupador = 1 /** N∆o Agrupa **/    AND   
                  bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta EXCLUSIVE-LOCK:
            ASSIGN bf{&tablename}.id-carga = pSerialCarga.
        END.
    END.

    FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    
    ASSIGN wm-etiqueta.id-carga = pSerialCarga.
    
    RELEASE wm-etiqueta.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaLogMultiplanta DBOProgram 
PROCEDURE atualizaLogMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param table for tt-mensagem.

for each tt-mensagem where
    substring(tt-mensagem.mensagem[1],01,01) = "E":U no-lock:

    for each RowObject:
        delete RowObject.
    end.

    create RowObject.
    assign RowObject.id-etiqueta          =  dec(substring(tt-mensagem.mensagem[1],02,15))
           &IF "{&mguni_version}" < "2.071" &THEN
            RowObject.cod-estabel          =      substring(tt-mensagem.mensagem[1],17,03) 
           &ENDIF
           RowObject.cod-item             =      substring(tt-mensagem.mensagem[1],20,16)
           RowObject.cod-refer            =      substring(tt-mensagem.mensagem[1],36,08)
           RowObject.cod-lote             =      substring(tt-mensagem.mensagem[1],44,40)
           RowObject.dt-validade-lote     = date(substring(tt-mensagem.mensagem[1],84,10))
           RowObject.ind-leitura-etiqueta =  int(substring(tt-mensagem.mensagem[1],94,02))
           &IF "{&mguni_version}" >= "2.071" &THEN
            RowObject.cod-estabel          =      substring(tt-mensagem.mensagem[1],96,05)
           &ENDIF
           RowObject.qtd-item             =  dec(substring(tt-mensagem.mensagem[2],01,16))
           RowObject.qtd-peso             =  dec(substring(tt-mensagem.mensagem[2],17,14))
           RowObject.cod-cliente          =  int(substring(tt-mensagem.mensagem[2],31,09))
           RowObject.cod-embalagem        =      substring(tt-mensagem.mensagem[2],40,10)
           RowObject.nr-pedido            =  int(substring(tt-mensagem.mensagem[2],50,11))
           &IF "{&mguni_version}" < "2.071" &THEN
            RowObject.cod-estabel-pedido   =      substring(tt-mensagem.mensagem[2],61,03)
           &ELSE
            RowObject.cod-estabel-pedido   =      substring(tt-mensagem.mensagem[2],61,05)
           &ENDIF
           RowObject.nr-ord-prod          =  int(substring(tt-mensagem.mensagem[3],01,11))
           &IF "{&mguni_version}" < "2.071" &THEN
            RowObject.cod-estabel-ord      =      substring(tt-mensagem.mensagem[3],12,03)
           &ENDIF
           RowObject.dt-geracao           = date(substring(tt-mensagem.mensagem[3],15,10))
           RowObject.hr-geracao           =  int(substring(tt-mensagem.mensagem[3],25,05))
           RowObject.dt-leitura           = date(substring(tt-mensagem.mensagem[3],30,10))
           RowObject.cod-usuario          =      substring(tt-mensagem.mensagem[3],40,12)
           RowObject.id-agrupador         =  dec(substring(tt-mensagem.mensagem[3],52,14))
           RowObject.ind-sit-agrupador    =  int(substring(tt-mensagem.mensagem[3],66,02)) 
           &IF "{&mguni_version}" >= "2.071" &THEN
            RowObject.cod-estabel-ord      =      substring(tt-mensagem.mensagem[3],68,05)
           &ENDIF
           RowObject.id-carga             =  dec(substring(tt-mensagem.mensagem[4],01,14))
           RowObject.log-impressa         =   if substring(tt-mensagem.mensagem[4],15,01) = "1":U then yes else no
           RowObject.log-reportada        =   if substring(tt-mensagem.mensagem[4],16,01) = "1":U then yes else no
           RowObject.ind-sit-estorno      =  int(substring(tt-mensagem.mensagem[4],17,02))
           RowObject.nome-abrev           = substring(tt-mensagem.mensagem[4],19,12)        
           RowObject.nr-pedcli            = substring(tt-mensagem.mensagem[4],31,12)        
           RowObject.int-1                = tt-mensagem.int-1
           RowObject.log-1                = tt-mensagem.log-1
           RowObject.char-1               = tt-mensagem.char-1
           RowObject.dec-1                = tt-mensagem.dec-1.   

    run setRecord in this-procedure (input table RowObject).
    run createRecord in this-procedure. 
    if return-value = "NOK":U then do:
        return "NOK":U.   
    end.

end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaQtdEtiqueta DBOProgram 
PROCEDURE atualizaQtdEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: O mÇtodo atualiza as quantidades que est∆o sendo retiradas no momento
         do picking.      
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pCodUsuario AS CHARACTER.
    DEF INPUT PARAM TABLE FOR ttSerialQtd.   

    FIND FIRST ttSerialQtd NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttSerialQtd THEN RETURN "NOK".
    
    FOR EACH ttSerialQtd:
        
        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerialQtd.id-etiqueta 
            EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL wm-etiqueta THEN NEXT.
        
        IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:   /* Agrupador */
            
            ASSIGN wm-etiqueta.qtd-item-retirado      = wm-etiqueta.qtd-item-retirado + ttSerialQtd.qtd-item-retirado
                   wm-etiqueta.cod-usuario-ult-acesso = pCodUsuario
                   wm-etiqueta.dt-ult-acesso          = TODAY
                   wm-etiqueta.hr-ult-acesso          = TIME.
            
            FOR EACH bf{&TableName} 
                WHERE bf{&tablename}.id-agrupador = wm-etiqueta.id-etiqueta EXCLUSIVE-LOCK:
                
                ASSIGN bf{&TableName}.qtd-item-retirado      = bf{&TableName}.qtd-item
                       bf{&TableName}.cod-usuario-ult-acesso = pCodUsuario
                       bf{&TableName}.dt-ult-acesso          = TODAY
                       bf{&TableName}.hr-ult-acesso          = TIME.
            
            
            END.
            
        END.
        ELSE DO:
        
            ASSIGN wm-etiqueta.qtd-item-retirado      = wm-etiqueta.qtd-item-retirado + ttSerialQtd.qtd-item-retirado
                   wm-etiqueta.cod-usuario-ult-acesso = pCodUsuario
                   wm-etiqueta.dt-ult-acesso          = TODAY
                   wm-etiqueta.hr-ult-acesso          = TIME.
            
            IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO: /* N∆o Agrupador */
            
                FIND FIRST bf{&TableName} 
                    WHERE bf{&tablename}.id-etiqueta = wm-etiqueta.id-agrupador 
                    EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL bf{&TableName} THEN 
                    ASSIGN bf{&TableName}.qtd-item-retirado      = bf{&TableName}.qtd-item-retirado + ttSerialQtd.qtd-item-retirado
                           bf{&TableName}.cod-usuario-ult-acesso = pCodUsuario
                           bf{&TableName}.dt-ult-acesso          = TODAY
                           bf{&TableName}.hr-ult-acesso          = TIME.
                
            END.
            
        END.
        
        RELEASE wm-etiqueta.
        RELEASE bf{&TableName}.
    END.
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hDBOWm-param) THEN
        RUN DESTROY IN hDBOWm-param.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desassociaAgrupCarga DBOProgram 
PROCEDURE desassociaAgrupCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em  desassociar um agrupador de uma carga. S¢ ser† poss°vel a 
  deassociaá∆o de uma etiqueta, caso a carga n∆o tenha sido enviada pelo MP e n∆o 
  esteja a carga vinculada Ö um documento (NF).
  Todas as etiquetas n∆o-agrupadoras pertencentes Ö etiqueta agrupadora ser∆o 
  atualizadas com o usu†rio e o id-carga = 0.

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodUsuario  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pSerialAgrup AS DECIMAL   NO-UNDO.

    DEF VAR c-agrupador AS CHAR NO-UNDO.
    
    ASSIGN c-agrupador = STRING(pSerialAgrup).
    
    FIND FIRST usuario-scm 
         WHERE usuario-scm.usuario = pCodUsuario NO-LOCK NO-ERROR.
        
    IF NOT AVAIL usuario-scm THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-usuario-2"}
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF NOT usuario-scm.log-utiliza-coletor THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26068"
                &ErrorType="EMS"
                &ErrorParameters="pCodUsuario"}

            RETURN "NOK":U.
        END.
    END. 
        
    FIND FIRST wm-etiqueta 
         WHERE wm-etiqueta.id-etiqueta = pSerialAgrup NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-4"}
        RETURN "NOK":U.
    END.
    
    /*******************************************************************
    ** Verifica a existencia de uma Etiqueta Agrupadora (Pallet) na   **
    ** mesma carga, para a Etiqueta Nao Agrupa (Item) informada.      **
    *******************************************************************/
    IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO:
        FIND FIRST b-wm-etiqueta
             WHERE b-wm-etiqueta.id-etiqueta = wm-etiqueta.id-agrupador AND
                   b-wm-etiqueta.id-carga    = wm-etiqueta.id-carga     NO-LOCK NO-ERROR.

        IF AVAIL b-wm-etiqueta THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="28409"
                &ErrorType="EMS"
                &ErrorParameters="STRING(wm-etiqueta.id-agrupador) + '~~~~' + STRING(wm-etiqueta.id-carga) + '~~~~' + STRING(wm-etiqueta.id-etiqueta)"}
            RETURN "NOK":U.
        END.
    END.

    IF wm-etiqueta.id-carga = 0  THEN DO:  /** N∆o associado a uma carga **/
        {method/svc/errors/inserr.i
            &ErrorNumber="26087"
            &ErrorType="EMS"
            &ErrorParameters="c-agrupador"}
        RETURN "NOK":U.
    END.
 
    FIND FIRST wm-carga 
         WHERE wm-carga.id-carga = wm-etiqueta.id-carga NO-LOCK NO-ERROR.
    
    IF AVAIL wm-carga THEN DO:
        IF  wm-carga.ind-enviado-mp = 2 AND
            CAN-FIND(FIRST wm-docto 
                     WHERE wm-docto.id-carga = wm-carga.id-carga) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26088"
                &ErrorType="EMS"
                &ErrorParameters="c-agrupador"}
            RELEASE wm-carga.
            RETURN "NOK":U.
        END.
    END.
    
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /** Agrupador de Etiquetas **/

        /** Atualiza as Etiquetas de Itens **/
        FOR EACH  bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9
            WHERE bf{&tablename}.ind-sit-agrupador = 1 /** N∆o Agrupa **/    AND
                  bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta EXCLUSIVE-LOCK:
            
            ASSIGN bf{&tablename}.id-carga    = 0
                   bf{&TableName}.cod-usuario = pCodUsuario.
        END.
    END.
            
    FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR.

    ASSIGN wm-etiqueta.id-carga    = 0
           wm-etiqueta.cod-usuario = pCodUsuario.
    
    RELEASE wm-carga.
    RELEASE bf{&TableName}.       
    RELEASE wm-etiqueta.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desassociaEtiquetas DBOProgram 
PROCEDURE desassociaEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: DESPALETIZACAO (desmonta todo o pallet)
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pCodUsuario  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pIdAgrupador LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR EACH RowErrors:
        DELETE RowErrors.
    END.

    FIND FIRST wm-etiqueta EXCLUSIVE-LOCK
        WHERE wm-etiqueta.id-etiqueta = pIdAgrupador NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        DEFINE VARIABLE c-lbl-liter-etiqueta-5 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-5 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-etiqueta-5"}
    END.

    IF  AVAIL wm-etiqueta
    AND wm-etiqueta.ind-sit-agrupador <> 2 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="26079"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(pIdAgrupador)"}
    END.

    IF CAN-FIND(FIRST wm-box-saldo-etiqueta NO-LOCK
                WHERE wm-box-saldo-etiqueta.id-etiqueta = pIdAgrupador)
    OR CAN-FIND(FIRST wm-movto-etiqueta NO-LOCK
                WHERE wm-movto-etiqueta.id-etiqueta = pIdAgrupador) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="55441"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(pIdAgrupador)"}
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    ASSIGN wm-etiqueta.qtd-item = 0
           wm-etiqueta.qtd-peso = 0.

    FOR EACH wm-etiqueta EXCLUSIVE-LOCK
        WHERE wm-etiqueta.id-agrupador = pIdAgrupador:
        ASSIGN wm-etiqueta.id-agrupador         = 0
               wm-etiqueta.ind-leitura-etiqueta = 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desassociaEtiquetasAgrup DBOProgram 
PROCEDURE desassociaEtiquetasAgrup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  Retira uma etiqueta nao agrupa do pallet (despaletiza unitario)
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id-etiqueta  LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
    DEF INPUT PARAM p-id-agrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR EACH RowErrors:
        DELETE RowErrors.
    END.

    /* valida agrupadora */
    FIND FIRST wm-etiqueta NO-LOCK
        WHERE wm-etiqueta.id-etiqueta = p-id-agrupador NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        DEFINE VARIABLE c-lbl-liter-etiqueta-6 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-6 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-etiqueta-6"}
    END.

    IF  AVAIL wm-etiqueta
    AND wm-etiqueta.ind-sit-agrupador <> 2 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="26079"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(p-id-agrupador)"}
    END.

    IF CAN-FIND(FIRST wm-box-saldo-etiqueta NO-LOCK
                WHERE wm-box-saldo-etiqueta.id-etiqueta = p-id-agrupador)
    OR CAN-FIND(FIRST wm-movto-etiqueta NO-LOCK
                WHERE wm-movto-etiqueta.id-etiqueta = p-id-agrupador) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="55441"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(p-id-agrupador)"}
    END.

    /* valida etiqueta item */
    FIND FIRST wm-etiqueta NO-LOCK
        WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        DEFINE VARIABLE c-lbl-liter-etiqueta-7 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-7 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-etiqueta-7"}
    END.

    IF  AVAIL wm-etiqueta
    AND wm-etiqueta.ind-sit-agrupador <> 1 THEN DO:
        DEFINE VARIABLE c-lbl-liter-nao-agrupa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "N∆o_Agrupa" *}
        ASSIGN c-lbl-liter-nao-agrupa = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="28304"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(p-id-etiqueta) + '~~~~' + c-lbl-liter-nao-agrupa"}
    END.

    IF CAN-FIND(FIRST wm-box-saldo-etiqueta NO-LOCK
                WHERE wm-box-saldo-etiqueta.id-etiqueta = p-id-etiqueta)
    OR CAN-FIND(FIRST wm-movto-etiqueta NO-LOCK
                WHERE wm-movto-etiqueta.id-etiqueta = p-id-etiqueta) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="26088"
                                    &ErrorType="EMS"
                                    &ErrorParameters="STRING(p-id-etiqueta)"}
    END.

    IF wm-etiqueta.id-agrupador <> p-id-agrupador THEN DO:
        DEFINE VARIABLE c-lbl-liter-etiqueta-8 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-8 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-agrupador AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Agrupador" *}
        ASSIGN c-lbl-liter-agrupador = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-merge-etiquetaagrupador AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-merge-etiquetaagrupador = c-lbl-liter-etiqueta-8 + "~~" + c-lbl-liter-agrupador.
        {method/svc/errors/inserr.i &ErrorNumber="19254"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-merge-etiquetaagrupador"}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RUN eliminaFormacaoAgrupador IN THIS-PROCEDURE (INPUT 2, /* elimina */
                                                    INPUT p-id-etiqueta,
                                                    INPUT p-id-agrupador,
                                                    INPUT wm-etiqueta.qtd-item,
                                                    INPUT wm-etiqueta.qtd-peso).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE devolveQtdEtiqueta DBOProgram 
PROCEDURE devolveQtdEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: O mÇtodo devolve as quantidades que foram retiradas no momento
         do picking.      
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pCodUsuario AS CHARACTER.
    DEF INPUT PARAM TABLE FOR ttSerialQtd.   

    FIND FIRST ttSerialQtd NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttSerialQtd THEN RETURN "NOK".
    
    FOR EACH ttSerialQtd:
        
        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerialQtd.id-etiqueta 
            EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL wm-etiqueta THEN NEXT.
        
        IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:   /* Agrupador */
            
            ASSIGN wm-etiqueta.qtd-item-retirado      = wm-etiqueta.qtd-item-retirado - ttSerialQtd.qtd-item-retirado
                   wm-etiqueta.cod-usuario-ult-acesso = pCodUsuario
                   wm-etiqueta.dt-ult-acesso          = TODAY
                   wm-etiqueta.hr-ult-acesso          = TIME.
            
            FOR EACH bf{&TableName} 
                WHERE bf{&tablename}.id-agrupador = wm-etiqueta.id-etiqueta EXCLUSIVE-LOCK:
                
                ASSIGN bf{&TableName}.qtd-item-retirado      = bf{&TableName}.qtd-item
                       bf{&TableName}.cod-usuario-ult-acesso = pCodUsuario
                       bf{&TableName}.dt-ult-acesso          = TODAY
                       bf{&TableName}.hr-ult-acesso          = TIME.
            
            
            END.
            
        END.
        ELSE DO:
        
            ASSIGN wm-etiqueta.qtd-item-retirado      = wm-etiqueta.qtd-item-retirado - ttSerialQtd.qtd-item-retirado
                   wm-etiqueta.cod-usuario-ult-acesso = pCodUsuario
                   wm-etiqueta.dt-ult-acesso          = TODAY
                   wm-etiqueta.hr-ult-acesso          = TIME.
            
            IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO: /* N∆o Agrupador */
            
                FIND FIRST bf{&TableName} 
                    WHERE bf{&tablename}.id-etiqueta = wm-etiqueta.id-agrupador 
                    EXCLUSIVE-LOCK NO-ERROR.
                
                ASSIGN bf{&TableName}.qtd-item-retirado      = bf{&TableName}.qtd-item-retirado - ttSerialQtd.qtd-item-retirado
                       bf{&TableName}.cod-usuario-ult-acesso = pCodUsuario
                       bf{&TableName}.dt-ult-acesso          = TODAY
                       bf{&TableName}.hr-ult-acesso          = TIME.
                
            END.
            
        END.
        
        RELEASE wm-etiqueta.
        RELEASE bf{&TableName}.
    END.
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estornaEtiquetas DBOProgram 
PROCEDURE estornaEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    
  Se a etiqueta for de pallet, estorna ela da carga.
  se a etiqueta for de item, estorna ela do pallet.

------------------------------------------------------------------------------*/

    DEF INPUT PARAM TABLE FOR ttSerial.          /* Temp-tables com os seriais dos itens a serem estornados  */

    DEF VAR c-serial AS CHAR NO-UNDO.

    FIND FIRST ttSerial NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttSerial THEN RETURN "NOK".
    
    FOR EACH ttSerial:
        
        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial 
            EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL wm-etiqueta THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-etiqueta-9 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Etiqueta" *}
            ASSIGN c-lbl-liter-etiqueta-9 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-etiqueta-9"}
            RETURN "NOK":U.
        END.
        
        /* Se for uma etiqueta de item que sofre associaá∆o */
        IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO:   /* Retira do pallet */
        
            /* Verificar se a etiqueta agrupadora desta etiqueta j† n∆o pertence a uma carga */
            IF wm-etiqueta.id-agrupador <> 0 THEN DO:
                FIND FIRST bf{&TableName} 
                    WHERE bf{&tablename}.id-etiqueta = wm-etiqueta.id-agrupador 
                    NO-LOCK NO-ERROR.
                
                IF AVAIL bf{&TableName} THEN
                    IF bf{&tablename}.id-carga <> 0  THEN DO:  /* J† pertence a uma carga */
                        ASSIGN c-serial = STRING(ttSerial.de-serial).
                        {method/svc/errors/inserr.i
                            &ErrorNumber="26009"
                            &ErrorType="EMS"
                            &ErrorParameters="c-serial"}
                        
                        NEXT.
                    END.                
            END.
            
            ASSIGN wm-etiqueta.id-agrupador         = 0
                   wm-etiqueta.ind-leitura-etiqueta = 4.  /* Estornado */
        
        END.
        ELSE DO:    /* Etiqueta de Pallet */
            
            IF wm-etiqueta.id-carga <> 0 THEN DO:            
                FIND FIRST wm-carga 
                    WHERE wm-carga.id-carga = wm-etiqueta.id-carga
                    NO-LOCK NO-ERROR.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-carga-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Carga" *}
                ASSIGN c-lbl-liter-carga-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-carga-2"}
                RELEASE wm-etiqueta.
                RETURN "NOK":U.
            END.
            
            ASSIGN wm-etiqueta.id-carga             = 0
                   wm-etiqueta.ind-leitura-etiqueta = 4.  /* Estornado */
        END.
    END.
    
    RELEASE bf{&TableName}.
    RELEASE wm-etiqueta.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE etiquetasAptasEstorno DBOProgram 
PROCEDURE etiquetasAptasEstorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em retornar as etiquetas agrupadoras de itens que j† foram 
  lidos para estorno. Este mÇtodo ser† utilizado no momento em que se fizer 
  estono de reporte de produá∆o, onde ser† informada a quantidade a ser 
  estornada. informada a ordem de produá∆o e o seu estabelecimento, e o mÇtodo 
  retorna todas as etiquetas agrupadoras aptas para estorno, com as suas 
  respectivas quantidades. Os dados poder∆o ser tratados e apresentados da 
  maneira que melhor atender Ös necessidades espec°ficas.
  
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pNrOrdProd     AS INTEGER.
    DEF INPUT  PARAM pCodEstabelOrd AS CHARACTER.
    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta. 
    
    FOR EACH ttWm-etiqueta:
        DELETE ttWm-etiqueta.
    END.


    FOR EACH wm-etiqueta USE-INDEX idx-wm-etiqueta7
        WHERE 
        wm-etiqueta.nr-ord-prod          = pNrOrdProd     AND
        wm-etiqueta.cod-estabel-ord      = pCodEstabelOrd AND
        wm-etiqueta.ind-sit-agrupador    <> 1             AND    /* S¢ de pallet                        */
        wm-etiqueta.ind-leitura-etiqueta <> 3             AND    /* <> de inutilizada                   */
        wm-etiqueta.id-carga             =  0             AND    /* Etiqueta n∆o vinculada a uma carga  */  
        wm-etiqueta.log-reportada        =  YES   
        NO-LOCK:
        
        DO TRANSACTION:
            CREATE ttWm-etiqueta.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta.
        END.    
        
    END.    
    RELEASE wm-etiqueta.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE etiquetasAptasReporte DBOProgram 
PROCEDURE etiquetasAptasReporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em retornar as etiquetas agrupadoras de itens que ainda n∆o 
  foram reportadas. Este mÇtodo ser† utilizado no momento de reporte de produá∆o, 
  onde ser† informada a quantidade produzida atÇ o momento. informada a ordem 
  de produá∆o e o seu estabelecimento, e o mÇtodo retorna todas as etiquetas 
  agrupadoras, com as suas respectivas quantidades. Os dados poder∆o ser tratados 
  e apresentados da maneira que melhor atender Ös necessidades espec°ficas.
  
  Obs.: N∆o h† necessidade de retornarem todas as etiquetas dos itens porque a 
  etiqueta agrupadora tem todas as informaá‰es sobre o que est† agrupando, 
  inclusive peso e quantidade total.

  Consideraá‰es: A ocorrància do atributo "ind-sit-estorno = 3" nas etiquetas 
  que retornarem na TT, indica que a mesma j† esteve em outra situaá∆o reportada 
  Ö produá∆o, e que, por algum motivo, foi estornada.

  
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pNrOrdProd     AS INTEGER.
    DEF INPUT  PARAM pCodEstabelOrd AS CHARACTER.
    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta. 
    
    FOR EACH ttWm-etiqueta:
        DELETE ttWm-etiqueta.
    END.

    FOR EACH wm-etiqueta USE-INDEX idx-wm-etiqueta7
        WHERE 
        wm-etiqueta.nr-ord-prod          = pNrOrdProd     AND
        wm-etiqueta.cod-estabel-ord      = pCodEstabelOrd AND
        wm-etiqueta.ind-sit-agrupador    <> 1             AND    /* S¢ de pallet     */
        wm-etiqueta.ind-leitura-etiqueta =  2             AND    /* Somente os lidos */
        wm-etiqueta.log-reportada        =  NO   
        NO-LOCK:
        

        DO TRANSACTION:
            CREATE ttWm-etiqueta.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta.
        END.    
        
    END.    
    
    RELEASE wm-etiqueta.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE etiquetasEstornadasRep DBOProgram 
PROCEDURE etiquetasEstornadasRep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  Ap¢s obter as informaá‰es sobre as etiquetas que podem serem estornadas do 
  reporte de produá∆o (pelo mÇtodo etiquetasAptasEstorno) e efetuado o estorno,  
  este mÇtodo deve ser executado, retornando ao WMS quais das etiquetas foram 
  efetivamente estornadas, para que elas sejam atualizadas de forma a n∆o 
  constarem em estorno de reporte futuro.  Essas etiquetas tàm seu status 
  retornado para "n∆o reportado".
  
  Obs.: Todas as etiquetas que pertencerem ao agrupador estornado, tambÇm 
  receber∆o o status de estornado. 

  Importante:  As etiquetas recebidas na ttWm-etiqueta n∆o s∆o validadas 
  novamente. A utilizaá∆o correta deste mÇtodo Ç precedida pela execuá∆o 
  do mÇtodo "etiquetasAptasEstorno", onde a integridade das etiquetas Ç garantida. 

------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR ttWm-etiqueta. 

    DEF VAR c-etiqueta AS CHARACTER NO-UNDO.

    /* Fazer as consistàncias das etiquetas recebidas */

    FOR EACH ttWm-etiqueta:
    
        FIND FIRST wm-etiqueta WHERE
            wm-etiqueta.id-etiqueta = ttWm-etiqueta.id-etiqueta 
            EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAIL wm-etiqueta THEN DO:
        
            IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /* Agrupador de Etiquetas */
                /* Atualiza as etiquetas de itens  */
                FOR EACH bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 WHERE 
                    bf{&tablename}.ind-sit-agrupador = 1 AND   /* N∆o agrupa */
                    bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta 
                    EXCLUSIVE-LOCK:
                    
                    ASSIGN bf{&TableName}.log-reportada   = NO
                           bf{&tablename}.ind-sit-estorno = 3.
                    
                    
                END.
            
            END.
            
            ASSIGN wm-etiqueta.log-reportada   = NO
                   wm-etiqueta.ind-sit-estorno = 3.
            
            RELEASE bf{&TableName}.
            
        END.            
        ELSE DO:
            
            ASSIGN c-etiqueta = STRING(ttWm-etiqueta.id-etiqueta).
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-etiqueta-10 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Etiqueta" *}
            ASSIGN c-lbl-liter-etiqueta-10 = TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-etiqueta-10 + ' ' + c-etiqueta "}
            RELEASE wm-etiqueta.    
            RETURN "NOK":U.
        END.
        
        RELEASE wm-etiqueta.
        
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE etiquetasReportadas DBOProgram 
PROCEDURE etiquetasReportadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  Ap¢s obter as informaá‰es sobre as etiquetas que podem serem reportadas Ö produá∆o 
  (pelo mÇtodo etiquetasAptasReporte) e efetuado o reporte,  este mÇtodo deve ser 
  executado, retornando ao WMS quais das etiquetas foram efetivamente reportadas, 
  para que elas sejam atualizadas de forma a n∆o constarem em reporte futuro. 

  Obs.: Todas as etiquetas que pertencerem ao agrupador reportado, tambÇm receber∆o 
  o status de reportadas. 

  Importante:  As etiquetas recebidas na ttWm-etiqueta n∆o s∆o validadas novamente. 
  A utilizaá∆o correta deste mÇtodo Ç precedida pela execuá∆o do mÇtodo 
  "etiquetasAptasReporte", onde a integridade das etiquetas Ç garantida. 
  
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR ttWm-etiqueta. 

    DEF VAR c-etiqueta AS CHARACTER NO-UNDO.

    FOR EACH ttWm-etiqueta:
    
    
        FIND FIRST wm-etiqueta WHERE
            wm-etiqueta.id-etiqueta = ttWm-etiqueta.id-etiqueta 
            EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAIL wm-etiqueta THEN DO:
        
            IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /* Agrupador de Etiquetas */
                /* Atualiza as etiquetas de itens  */
                FOR EACH bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 WHERE
                    bf{&tablename}.ind-sit-agrupador = 1 AND   /* N∆o agrupa */
                    bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta 
                    EXCLUSIVE-LOCK:
                    
                    ASSIGN bf{&TableName}.log-reportada = YES.            
                
                END.
            
            END.
            
            ASSIGN wm-etiqueta.log-reportada = YES.
            RELEASE bf{&TableName}.
            
        END.            
        ELSE DO:
            
            ASSIGN c-etiqueta = STRING(ttWm-etiqueta.id-etiqueta).
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-etiqueta-11 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Etiqueta" *}
            ASSIGN c-lbl-liter-etiqueta-11 = TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-etiqueta-11 + ' ' + c-etiqueta "}
                
            RETURN "NOK":U.
        END.
    
        RELEASE wm-etiqueta.
        
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excluiInutilizadas DBOProgram 
PROCEDURE excluiInutilizadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: O mÇtodo consiste em excluir da entidade todas as etiquetas que por 
         algum motivo n∆o foram utilizadas pelo sistema. Neste caso todas as
         etiquetas com ind-leitura-etiqueta = 3 (inutilizado) e todas as 
         etiquetas n∆o agrupadoras que n∆o estejam vinculadas a um agrupador.
       
------------------------------------------------------------------------------*/
    
    DEF VAR i-num-dias     AS INTEGER   NO-UNDO.
    DEF VAR c-valor        AS CHARACTER NO-UNDO.
    DEF VAR dt-data-limite AS DATE      NO-UNDO.
    
    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    RUN getInfoPadrao IN hDBOWm-Param (INPUT "num-dias-historico-etiq":U, OUTPUT c-valor).
    
    ASSIGN i-num-dias = INTEGER(c-valor)
           dt-data-limite = TODAY - i-num-dias.
    
/*    FOR EACH wm-etiqueta WHERE
 *         wm-etiqueta.dt-geracao           < dt-data-limite      AND
 *         wm-etiqueta.ind-leitura-etiqueta = 3 /* Inutilizado */ AND
 *         wm-etiqueta. 
 *     */
    
    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formacaoAgrupador DBOProgram 
PROCEDURE formacaoAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM i-opcao   AS INTEGER NO-UNDO.  /* 1 = Add - 2 = Del - 3 = DelAll */
DEF INPUT PARAM p-id-etiqueta  LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
DEF INPUT PARAM p-id-agrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.
DEF INPUT PARAM p-qtd-item     LIKE wm-etiqueta.qtd-item     NO-UNDO.
DEF INPUT PARAM p-qtd-peso     LIKE wm-etiqueta.qtd-peso     NO-UNDO.
DEF INPUT PARAM p-cod-estabel  LIKE wm-etiqueta.cod-estabel  NO-UNDO.
DEF INPUT PARAM p-cod-local    LIKE wm-docto.cod-local       NO-UNDO.


    IF p-cod-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="366"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local"}
        RETURN "NOK".    
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-local = p-cod-local) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local-2 + ' ' + p-cod-local"}
        RETURN "NOK".
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-estabel = p-cod-estabel
                      AND wm-local.cod-local   = p-cod-local) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="25765"
                                    &ErrorType="EMS"
                                    &ErrorParameters="p-cod-local"}
        RETURN "NOK".
    END.

    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta   = p-id-agrupador EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        IF i-opcao = 1 THEN DO:
            FIND FIRST wm-item-embalagem-local USE-INDEX idx-wm-item-embalagem-local1 WHERE
                wm-item-embalagem-local.cod-estabel   = p-cod-estabel           AND
                wm-item-embalagem-local.cod-local     = p-cod-local             AND
                wm-item-embalagem-local.cod-item      = wm-etiqueta.cod-item    AND
                wm-item-embalagem-local.cod-embalagem = wm-etiqueta.cod-embalagem NO-LOCK NO-ERROR.
            IF NOT AVAIL wm-item-embalagem-local THEN DO: 
                {method/svc/errors/inserr.i 
                        &ErrorNumber="55135"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
                RETURN "NOK".
            END.
            ELSE DO: 
            IF wm-item-embalagem-local.qtd-item < wm-etiqueta.qtd-item + p-qtd-item THEN DO:
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="34134"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
                RETURN "NOK".
            END.
            END.
                        
            ASSIGN wm-etiqueta.qtd-item = wm-etiqueta.qtd-item + p-qtd-item
                   wm-etiqueta.qtd-peso = wm-etiqueta.qtd-peso + p-qtd-peso.
        END.
        ELSE IF i-opcao = 2 OR i-opcao = 3 THEN
            ASSIGN wm-etiqueta.qtd-item = wm-etiqueta.qtd-item - p-qtd-item
                   wm-etiqueta.qtd-peso = wm-etiqueta.qtd-peso - p-qtd-peso.
        RELEASE wm-etiqueta.
    END.
    ELSE
        RETURN "NOK":U.

    FIND FIRST wm-etiqueta WHERE 
         wm-etiqueta.id-etiqueta  = p-id-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        IF i-opcao = 1 THEN DO:
            ASSIGN wm-etiqueta.id-agrupador = p-id-agrupador
                   wm-etiqueta.dt-leitura   = TODAY.
        END.
        ELSE DO:
            IF i-opcao = 2 OR i-opcao = 3 THEN 
                ASSIGN wm-etiqueta.id-agrupador = 0.
        END.
        RELEASE wm-etiqueta.
    END.
    ELSE
        RETURN "NOK":U.
          
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reportaEtiqueta DBOProgram 
PROCEDURE reportaEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-id-agrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.

IF p-id-agrupador <> 0 THEN DO:
    FOR FIRST wm-etiqueta
        WHERE wm-etiqueta.id-etiqueta = p-id-agrupador EXCLUSIVE-LOCK:
        IF NOT CAN-FIND(FIRST bfwm-etiqueta WHERE
                              bfwm-etiqueta.id-agrupador  = wm-etiqueta.id-etiqueta    AND
                              bfwm-etiqueta.log-reportada = NO  NO-LOCK) THEN DO:
              ASSIGN wm-etiqueta.log-reportada = YES.
        END.
        ELSE DO:
            ASSIGN wm-etiqueta.log-reportada = NO.
        END.
    END.
END.
          
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaFormacaoAgrupador DBOProgram 
PROCEDURE eliminaFormacaoAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM i-opcao   AS INTEGER NO-UNDO.  /* 1 = Add 2 = Del 3 = DelAll */
DEF INPUT PARAM p-id-etiqueta  LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
DEF INPUT PARAM p-id-agrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.
DEF INPUT PARAM p-qtd-item     LIKE wm-etiqueta.qtd-item     NO-UNDO.
DEF INPUT PARAM p-qtd-peso     LIKE wm-etiqueta.qtd-peso     NO-UNDO.

FIND FIRST wm-etiqueta WHERE
    wm-etiqueta.id-etiqueta   = p-id-agrupador EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL wm-etiqueta THEN DO:
    IF i-opcao = 1 THEN DO:
        FIND FIRST wm-item-embalagem-local USE-INDEX idx-wm-item-embalagem-local1 WHERE
            wm-item-embalagem-local.cod-estabel   = wm-etiqueta.cod-estabel AND
            wm-item-embalagem-local.cod-item      = wm-etiqueta.cod-item    AND
            wm-item-embalagem-local.cod-embalagem = wm-etiqueta.cod-embalagem NO-LOCK NO-ERROR.
        IF wm-item-embalagem-local.qtd-item < wm-etiqueta.qtd-item + p-qtd-item THEN DO:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="34134"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
            RETURN "NOK".
        END.
        ASSIGN wm-etiqueta.qtd-item = wm-etiqueta.qtd-item + p-qtd-item
               wm-etiqueta.qtd-peso = wm-etiqueta.qtd-peso + p-qtd-peso.
    END.
    ELSE IF i-opcao = 2 OR i-opcao = 3 THEN 
        ASSIGN wm-etiqueta.qtd-item = wm-etiqueta.qtd-item - p-qtd-item
               wm-etiqueta.qtd-peso = wm-etiqueta.qtd-peso - p-qtd-peso.
    RELEASE wm-etiqueta.
END.
ELSE
    RETURN "NOK":U.
          
FIND FIRST wm-etiqueta WHERE 
     wm-etiqueta.id-etiqueta  = p-id-etiqueta EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL wm-etiqueta THEN DO:

    IF i-opcao = 1 THEN
        ASSIGN wm-etiqueta.id-agrupador = p-id-agrupador
               wm-etiqueta.dt-leitura   = TODAY.
    ELSE IF i-opcao = 2 OR i-opcao = 3 THEN 
        ASSIGN wm-etiqueta.id-agrupador = 0.
    RELEASE wm-etiqueta.
END.
ELSE
    RETURN "NOK":U.
          
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formacaoAgrupadorProprioTransfEnd DBOProgram 
PROCEDURE formacaoAgrupadorProprioTransfEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-id-etiqueta       LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
DEF INPUT PARAM p-id-agrupador      LIKE wm-etiqueta.id-agrupador NO-UNDO.
DEF INPUT PARAM p-qtd-item          LIKE wm-etiqueta.qtd-item     NO-UNDO.
DEF INPUT PARAM p-qtd-peso          LIKE wm-etiqueta.qtd-peso     NO-UNDO.
DEF INPUT PARAM p-cod-estabel       LIKE wm-etiqueta.cod-estabel  NO-UNDO.
DEF INPUT PARAM p-cod-local         LIKE wm-docto.cod-local       NO-UNDO.


    IF p-cod-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="366"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local"}
        RETURN "NOK".    
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-local = p-cod-local) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local-2 + ' ' + p-cod-local"}
        RETURN "NOK".
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-estabel = p-cod-estabel
                      AND wm-local.cod-local   = p-cod-local) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="25765"
                                    &ErrorType="EMS"
                                    &ErrorParameters="p-cod-local"}
        RETURN "NOK".
    END.

    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta   = p-id-agrupador EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item-retirado - p-qtd-item
               wm-etiqueta.ind-leitura-etiqueta = 2
               wm-etiqueta.log-1 = YES.
    END.

    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta   = p-id-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
            ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item-retirado + p-qtd-item.
            FIND FIRST wm-box-saldo-etiqueta EXCLUSIVE-LOCK
                 WHERE wm-box-saldo-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta NO-ERROR.
            IF AVAIL wm-box-saldo-etiqueta THEN DO:
                FIND FIRST wm-box-saldo EXCLUSIVE-LOCK
                     WHERE wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
                       AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local
                       AND wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo NO-ERROR.
                IF AVAIL wm-box-saldo THEN DO:
                    ASSIGN wm-box-saldo.qtd-item-bloq        = wm-box-saldo.qtd-item-bloq + p-qtd-item.
                    IF  wm-box-saldo.qtd-item = wm-box-saldo.qtd-item-bloq THEN DO:
                        DELETE wm-box-saldo.
                    END.
                END.
                if  wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item then
                    delete wm-box-saldo-etiqueta.
            END.
        RELEASE wm-etiqueta.
    END.
    ELSE
        RETURN "NOK":U.
       
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formacaoAgrupadorTransfEnd DBOProgram 
PROCEDURE formacaoAgrupadorTransfEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM i-opcao   AS INTEGER NO-UNDO.  /* 1 = Add - 2 = Del - 3 = DelAll */
DEF INPUT PARAM p-id-etiqueta  LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
DEF INPUT PARAM p-id-agrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.
DEF INPUT PARAM p-qtd-item     LIKE wm-etiqueta.qtd-item     NO-UNDO.
DEF INPUT PARAM p-qtd-peso     LIKE wm-etiqueta.qtd-peso     NO-UNDO.
DEF INPUT PARAM p-cod-estabel  LIKE wm-etiqueta.cod-estabel  NO-UNDO.
DEF INPUT PARAM p-cod-local    LIKE wm-docto.cod-local       NO-UNDO.


    IF p-cod-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="366"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local"}
        RETURN "NOK".    
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-local = p-cod-local) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-local-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Local" *}
        ASSIGN c-lbl-liter-local-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-local-2 + ' ' + p-cod-local"}
        RETURN "NOK".
    END.
    IF NOT CAN-FIND(FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-estabel = p-cod-estabel
                      AND wm-local.cod-local   = p-cod-local) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="25765"
                                    &ErrorType="EMS"
                                    &ErrorParameters="p-cod-local"}
        RETURN "NOK".
    END.

    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta   = p-id-agrupador EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        IF i-opcao = 1 THEN DO:
            FIND FIRST wm-item-embalagem-local USE-INDEX idx-wm-item-embalagem-local1 WHERE
                wm-item-embalagem-local.cod-estabel   = p-cod-estabel           AND
                wm-item-embalagem-local.cod-local     = p-cod-local             AND
                wm-item-embalagem-local.cod-item      = wm-etiqueta.cod-item    AND
                wm-item-embalagem-local.cod-embalagem = wm-etiqueta.cod-embalagem NO-LOCK NO-ERROR.
            IF wm-item-embalagem-local.qtd-item < wm-etiqueta.qtd-item + p-qtd-item THEN DO:
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="34134"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
                RETURN "NOK".
            END.
            ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item-retirado - p-qtd-item
                   wm-etiqueta.ind-leitura-etiqueta = 2
                   wm-etiqueta.log-1 = YES.
        END.
        ELSE IF i-opcao = 2 OR i-opcao = 3 THEN
            ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item-retirado + p-qtd-item.
            FIND FIRST wm-box-saldo-etiqueta EXCLUSIVE-LOCK
                 WHERE wm-box-saldo-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta NO-ERROR.
            IF AVAIL wm-box-saldo-etiqueta THEN DO:
                FIND FIRST wm-box-saldo EXCLUSIVE-LOCK
                     WHERE wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
                       AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local
                       AND wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo NO-ERROR.
                IF AVAIL wm-box-saldo THEN DO:
                    ASSIGN wm-box-saldo.qtd-item-bloq        = wm-box-saldo.qtd-item-bloq + p-qtd-item.
                    IF  wm-box-saldo.qtd-item = wm-box-saldo.qtd-item-bloq THEN DO:
                        DELETE wm-box-saldo.
                    END.
                END.
                if  wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item then
                    delete wm-box-saldo-etiqueta.
            END.
        RELEASE wm-etiqueta.
    END.
    ELSE
        RETURN "NOK":U.

    FIND FIRST wm-etiqueta WHERE 
         wm-etiqueta.id-etiqueta  = p-id-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        IF i-opcao = 1 THEN DO:
            ASSIGN wm-etiqueta.id-agrupador = p-id-agrupador
                   wm-etiqueta.dt-leitura   = TODAY.
        END.
        ELSE DO:
            IF i-opcao = 2 OR i-opcao = 3 THEN 
                ASSIGN wm-etiqueta.id-agrupador = 0.
        END.
        RELEASE wm-etiqueta.
    END.
    ELSE
        RETURN "NOK":U.
          
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAgrupEtiquetaLida DBOProgram 
PROCEDURE geraAgrupEtiquetaLida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

    Gera etiqueta agrupadora de itens (itens com o status de lido). o mÇtodo 
    receber† uma Temp-Table com os seriais dos itens que ser∆o agrupados 
    por essa etiqueta agrupadora.
    O atributo "id-agrupador" das etiquetas dos itens receber† o "id-etiqueta" 
    da etiqueta agrupadora.



    O mÇtodo gera uma etiqueta de agrupador  (ind-sit-agrupador = 2    
    /* AGRUPA ETIQUETAS */), e atualiza o id-agrupador das etiquetas passadas na TT.  
    A etiqueta Ç gerada com o status de lida (ind-leitura-etiqueta = 2    /* LIDA */), 
    o que caracteriza o fechamento do pallet.
    Os atributos de quantidade (item e peso) das etiquetas que ser∆o agrupadas 
    ser∆o somados e o total gravado no registro da etiqueta agrupadora. 
    Os demais dados da etiqueta ser∆o gerados com base em uma etiqueta de item 
    pertencente ao agrupador gerado.


------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pCodUsuario AS CHARACTER.
    DEF INPUT  PARAM TABLE FOR ttSerial.          /* Temp-table com os seriais dos itens gerados para serem agrupados  */
    DEF OUTPUT PARAM pSerialAgrup AS DECIMAL.     /* Serial do Agrupador   */

    DEF VAR c-cod-estabel     LIKE wm-etiqueta.cod-estabel     NO-UNDO.
    DEF VAR de-qtd-item       LIKE wm-etiqueta.qtd-item        NO-UNDO.
    DEF VAR de-qtd-peso       LIKE wm-etiqueta.qtd-peso        NO-UNDO.
    DEF VAR l-first           AS LOGICAL                       NO-UNDO.
    DEF VAR c-cod-item        LIKE wm-etiqueta.cod-item        NO-UNDO.
    DEF VAR c-cod-refer       LIKE wm-etiqueta.cod-refer       NO-UNDO.
    DEF VAR c-cod-lote        LIKE wm-etiqueta.cod-lote        NO-UNDO.
    DEF VAR c-cod-estabel-ord LIKE wm-etiqueta.cod-estabel-ord NO-UNDO.
    DEF VAR i-nr-ord-prod     LIKE wm-etiqueta.nr-ord-prod     NO-UNDO.
   

    
    FIND FIRST ttSerial NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttSerial THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tt-seriais AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "TT_Seriais" *}
        ASSIGN c-lbl-liter-tt-seriais = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-tt-seriais"}
            RETURN "NOK".
    END.
    
    
    /* Verifica se todos os seriais tàm o mesmo item / referància / lote / Estabel OP / OP  */
    
    ASSIGN l-first = NO.
    
    FOR EACH ttSerial:
        
        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial NO-LOCK NO-ERROR.
            
        IF NOT AVAIL wm-etiqueta THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-etiqueta-12 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Etiqueta" *}
            ASSIGN c-lbl-liter-etiqueta-12 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-etiqueta-12"}
            RETURN "NOK".
        END.
        
        
        IF NOT l-first THEN DO:
            ASSIGN l-first = YES
                   c-cod-item        = wm-etiqueta.cod-item
                   c-cod-refer       = wm-etiqueta.cod-refer
                   c-cod-lote        = wm-etiqueta.cod-lote
                   c-cod-estabel-ord = wm-etiqueta.cod-estabel-ord
                   i-nr-ord-prod     = wm-etiqueta.nr-ord-prod.
        END.                   
        ELSE DO:
        
            IF wm-etiqueta.ind-sit-agrupador <> 1 THEN DO:   /* Somente etiquetas n∆o agrupadoras */
                {method/svc/errors/inserr.i
                    &ErrorNumber="26005"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
            END.

            IF c-cod-item <> wm-etiqueta.cod-item THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-itens AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Itens" *}
                ASSIGN c-lbl-liter-itens = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26383"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-itens"}
            END.
        
            IF c-cod-refer <> wm-etiqueta.cod-refer THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-referencias AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Referàncias" *}
                ASSIGN c-lbl-liter-referencias = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26383"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-referencias"}
            END.
        
            IF c-cod-lote <> wm-etiqueta.cod-lote THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-lotes AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Lotes" *}
                ASSIGN c-lbl-liter-lotes = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26383"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-lotes"}
            END.
        
            IF c-cod-estabel-ord <> wm-etiqueta.cod-estabel-ord THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-estabelecimento-das-ordens-de AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Estabelecimento_das_Ordens_de_Produá∆o" *}
                ASSIGN c-lbl-liter-estabelecimento-das-ordens-de = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26383"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-estabelecimento-das-ordens-de"} /*n∆o alterar a descriá∆o da mensagem, pois h† uma EPC na VIPAL baseada na descriá∆o*/
            END.
            
            IF i-nr-ord-prod <> wm-etiqueta.nr-ord-prod THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ordens-de-producao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ordens_de_Produá∆o" *}
                ASSIGN c-lbl-liter-ordens-de-producao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26383"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-ordens-de-producao"} /*n∆o alterar a descriá∆o da mensagem, pois h† uma EPC na VIPAL baseada na descriá∆o*/
            END.        
        END.
    END.
    
    /**********************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: Vipal / FO: 1083.082 ***/
    /**********************************************************/
    /*** Prop¢sito: Permitir que se possa incluir no mesmo  ***/
    /***            agrupador, itens de ordens de produá∆o  ***/
    /***            diferentes. Assim, a mensagem 26383     ***/
    /***            gerada para ordem de produá∆o deve ser  ***/
    /***            eliminada.                              ***/
    /*** Obs.: O ponto EPC permite que todas as mensagens   ***/
    /***       geradas sejam manipuladas. Entretanto, esta  ***/
    /***       manipulaá∆o s¢ Ç poss°vel atravÇs da descri- ***/
    /***       á∆o da mensagem.                             ***/
    /**********************************************************/

    {method/svc/custom/custom.i &Event="DeleteMessage"}

    IF  CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType    <> "INTERNAL":U
        AND   RowErrors.ErrorSubType = "Error":U) THEN DO:
        RELEASE wm-etiqueta.
        RETURN "NOK":U.
    END.
    
    /**********************************************************/
    /*** FIM CHAMADA EPC - Cliente: Vipal / FO: 1083.082    ***/
    /**********************************************************/
    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    /* Pega estabelecimento padr∆o */
    RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-cod-estabel).
    
    /* Gera um serial de etiqueta */    
    FOR EACH ttSerialAux:
        DELETE ttSerialAux.
    END.
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerialAux, INPUT 1).

    /* N∆o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
             
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).        
    
    
    ASSIGN de-qtd-item = 0
           de-qtd-peso = 0.           
    
    
    /* Sumariza os itens */
    FOR EACH ttSerial:

        FIND FIRST wm-etiqueta 
            WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial EXCLUSIVE-LOCK NO-ERROR.
            
        IF AVAIL wm-etiqueta THEN DO:
            ASSIGN de-qtd-peso = de-qtd-peso + wm-etiqueta.qtd-peso
                   de-qtd-item = de-qtd-item + wm-etiqueta.qtd-item.
            IF wm-etiqueta.dt-leitura = ? THEN
                ASSIGN wm-etiqueta.dt-leitura           = TODAY
                       wm-etiqueta.ind-leitura-etiqueta = 2    /*    LIDA       */.
                
        END.
        
    END.
    
        
    /* REGISTRO DE ETIQUETA AGRUPADORA */    
    FOR EACH ttSerialAux:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.
        
        CREATE RowObject.
        ASSIGN pSerialAgrup                   = ttSerialAux.de-serial
               RowObject.cod-cliente          = wm-etiqueta.cod-cliente
               RowObject.cod-embalagem        = wm-etiqueta.cod-embalagem
               RowObject.cod-estabel          = wm-etiqueta.cod-estabel  /* c-cod-estabel */
               RowObject.cod-estabel-ord      = wm-etiqueta.cod-estabel-ord
               RowObject.cod-estabel-pedido   = wm-etiqueta.cod-estabel-pedido
               RowObject.cod-item             = wm-etiqueta.cod-item
               RowObject.cod-lote             = wm-etiqueta.cod-lote
               RowObject.cod-refer            = wm-etiqueta.cod-refer
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY
               RowObject.dt-validade-lote     = wm-etiqueta.dt-validade-lote
               RowObject.hr-geracao           = TIME        
               RowObject.id-etiqueta          = ttSerialAux.de-serial
               RowObject.ind-leitura-etiqueta = 2    /*       LIDA       */
               RowObject.nr-ord-prod          = wm-etiqueta.nr-ord-prod
               RowObject.nr-pedido            = wm-etiqueta.nr-pedido
               RowObject.nr-pedcli            = wm-etiqueta.nr-pedcli
               RowObject.nome-abrev           = wm-etiqueta.nome-abrev
               RowObject.qtd-item             = de-qtd-item
               RowObject.qtd-peso             = de-qtd-peso
               RowObject.cod-usuario          = pCodUsuario
               RowObject.id-agrupador         = 0
               RowObject.id-carga             = 0
               RowObject.ind-sit-agrupador    = 2    /* AGRUPA ETIQUETAS */
               RowObject.log-impressa         = YES  /* Em princ°pio, toda etiqueta solicitada pelo coletor ter† este status */
               RowObject.log-reportada        = NO.

               
        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    RELEASE wm-etiqueta.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    /* ATUALIZAÄ«O DE ETIQUETAS DE ITEM */
    FIND FIRST ttSerialAux NO-LOCK NO-ERROR.
    
    FOR EACH ttSerial:
        FIND FIRST wm-etiqueta WHERE 
            wm-etiqueta.id-etiqueta = ttSerial.de-serial EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAIL wm-etiqueta THEN DO:

            ASSIGN wm-etiqueta.id-agrupador = ttSerialAux.de-serial.
            RELEASE wm-etiqueta.
        END.        
        
    END.
    
    RELEASE wm-etiqueta.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetaAgrupador DBOProgram 
PROCEDURE geraEtiquetaAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 ------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pCodUsuario  AS CHARACTER.
    DEF INPUT  PARAM pQtdEtiqueta  AS INTEGER.    /* Quantidade de etiquetas (seriais) a serem geradas */
    DEF OUTPUT PARAM TABLE FOR ttSerial.          /* Temp-tables com o(s) serial(ais) gerado(s)        */

    DEF VAR c-cod-estabel LIKE wm-etiqueta.cod-estabel NO-UNDO.

    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    /* Pega estabelecimento padr∆o */
    RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-cod-estabel).
    
    /* Gera um serial de etiqueta */    
    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerial, INPUT pQtdEtiqueta).

    /* N∆o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).        
    
    /* REGISTRO DE ETIQUETA AGRUPADORA */    
    FOR EACH ttSerial:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.
        
        CREATE RowObject.
        ASSIGN RowObject.cod-cliente          = 0
               RowObject.cod-embalagem        = "":U
               RowObject.cod-estabel          = c-cod-estabel
               RowObject.cod-estabel-ord      = "":U
               RowObject.cod-estabel-pedido   = "":U
               RowObject.cod-item             = "":U
               RowObject.cod-lote             = "":U
               RowObject.cod-refer            = "":U
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY
               RowObject.dt-validade-lote     = TODAY
               RowObject.hr-geracao           = TIME        
               RowObject.id-etiqueta          = ttSerial.de-serial
               RowObject.ind-leitura-etiqueta = 1    /* N«O LIDA       */
               RowObject.nr-ord-prod          = 0
               RowObject.nr-pedido            = 0
               RowObject.qtd-item             = 0
               RowObject.qtd-peso             = 0
               RowObject.cod-usuario          = pCodUsuario
               RowObject.id-agrupador         = 0
               RowObject.id-carga             = 0
               RowObject.ind-sit-agrupador    = 2    /* AGRUPA ETIQUETAS */.

               
        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetaItemUnico DBOProgram 
PROCEDURE geraEtiquetaItemUnico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

    Gera etiquetas de item que ocupa 100% do agrupador (mantas, no caso Vipal)
   gerada uma etiqueta que identifica o item e o agrupador ao mesmo tempo.


    O mÇtodo gera uma etiqueta de item/agrupador (ind-sit-agrupador = 3  
    /* AGRUPADOR PR‡PRIO*/), com id-agrupador igual ao id-etiqueta gerado. 
    Consiste os dados passados na ttWm-etiqueta, porque trata-se de um item 
    normal, com a diferenáa que o agrupador Ç o pr¢prio item.
------------------------------------------------------------------------------*/
    
    DEF INPUT  PARAM TABLE FOR ttWm-etiqueta.     /* Matriz da etiqueta a ser gerada    */
    DEF OUTPUT PARAM pSerialAgrup AS DECIMAL.     /* Serial do Item/Agrupador           */


    DEF VAR c-valor AS CHAR NO-UNDO.

    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    
    FIND FIRST ttWm-etiqueta NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttWm-etiqueta THEN RETURN "NOK".
    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    IF ttWm-etiqueta.Cod-cliente = 0 THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Cliente":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-cliente = INTEGER(c-valor).
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel = c-valor.
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel-ord) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-ord = c-valor.
    END.

    IF TRIM(ttWm-etiqueta.Cod-estabel-pedido) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-pedido = c-valor.
    END.
    
    
    IF TRIM(ttWm-etiqueta.Cod-embalagem) <> "":U THEN DO:

        FIND FIRST wm-embalagem WHERE
            wm-embalagem.cod-embalagem = RowObject.cod-embalagem NO-LOCK NO-ERROR.
            
        IF NOT AVAIL wm-embalagem THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embalagem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-embalagem"}
            RETURN "NOK":U.
        END.
        
    END.

    
    IF TRIM(ttWm-etiqueta.Cod-embalagem) = "":U THEN DO:

        FIND FIRST wm-local
             WHERE wm-local.cod-estabel      = ttWm-etiqueta.cod-estabel AND
                   wm-local.log-local-padrao = YES NO-LOCK NO-ERROR.
    
        /* Se existir embalagem item local padr∆o para o item */
        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = ttWm-etiqueta.cod-estabel AND
                   wm-item-embalagem-local.cod-local   = wm-local.cod-local        AND
                   wm-item-embalagem-local.cod-item    = ttWm-etiqueta.Cod-item    AND
                   wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.

        IF AVAIL wm-item-embalagem-local THEN
            ASSIGN ttWm-etiqueta.cod-embalagem = wm-item-embalagem-local.cod-embalagem.
        ELSE DO:
            /* Caso n∆o exista embalagem item local padr∆o para o item, pega dos parÉmetros do WMS */
            RUN getInfoPadrao IN hDBOWm-Param (INPUT "embalagem":U, OUTPUT c-valor).
            ASSIGN ttWm-etiqueta.cod-embalagem = c-valor.

            FIND FIRST wm-embalagem 
                 WHERE wm-embalagem.cod-embalagem   = c-valor NO-LOCK NO-ERROR.

            CREATE wm-item-embalagem-local.
            ASSIGN wm-item-embalagem-local.cod-estabel        = ttWm-etiqueta.cod-estabel
                   wm-item-embalagem-local.cod-local          = wm-local.cod-local
                   wm-item-embalagem-local.cod-embalagem      = c-valor
                   wm-item-embalagem-local.cod-item           = ttWm-etiqueta.Cod-item
                   wm-item-embalagem-local.log-abre-embalagem = NO
                   wm-item-embalagem-local.log-padrao         = YES
                   wm-item-embalagem-local.qtd-item-emb       = 1
                   wm-item-embalagem-local.qtd-min-item-emb   = 0
                   wm-item-embalagem-local.qtd-peso           = wm-embalagem.qtd-peso
                   wm-item-embalagem-local.qtd-volume         = wm-embalagem.qtd-altura * wm-embalagem.qtd-comprimento * wm-embalagem.qtd-largura.
        END.
    END.
    
    CREATE RowObject.
    ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
           RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
           RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
           RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
           RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
           RowObject.cod-item             = ttWm-etiqueta.Cod-item
           RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
           RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
           RowObject.dt-geracao           = ttWm-etiqueta.Dt-geracao
           RowObject.dt-leitura           = TODAY
           RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
           RowObject.hr-geracao           = ttWm-etiqueta.Hr-geracao
           RowObject.ind-leitura-etiqueta = 2    /*    LIDA       */
           RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
           RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
           RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
           RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev           
           RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
           RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
           RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
           RowObject.ind-sit-agrupador    = 3    /* AGRUPADOR PR‡PRIO */
           RowObject.log-reportada        = ttWm-etiqueta.log-reportada.

    RUN EmptyRowErrors IN THIS-PROCEDURE.
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK".
    END.
    
    
    /* Gera um serial de etiqueta */    
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerial, INPUT 1).

    /* N∆o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
             
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).        
        
    FOR EACH ttSerial:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.
        
        CREATE RowObject.
        ASSIGN pSerialAgrup                   = ttSerial.de-serial
               RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
               RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
               RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
               RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
               RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
               RowObject.cod-item             = ttWm-etiqueta.Cod-item
               RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
               RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY 
               RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
               RowObject.hr-geracao           = TIME  
               RowObject.ind-leitura-etiqueta = 2    /* LIDA       */
               RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
               RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
               RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
               RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev           
               RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
               RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
               RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
               RowObject.id-agrupador         = pSerialAgrup
               RowObject.id-etiqueta          = pSerialAgrup
               RowObject.id-carga             = 0
               RowObject.ind-sit-agrupador    = 3    /* AGRUPADOR PR‡PRIO */
               RowObject.log-impressa         = ttWm-etiqueta.log-impressa
               RowObject.log-reportada        = ttWm-etiqueta.log-reportada.

        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetaItemUnicoNaoLido DBOProgram 
PROCEDURE geraEtiquetaItemUnicoNaoLido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

    Gera etiquetas de item que ocupa 100% do agrupador (mantas, no caso Vipal)
    gerada uma etiqueta que identifica o item e o agrupador ao mesmo tempo.


    O mÇtodo gera uma etiqueta de item/agrupador (ind-sit-agrupador = 3  
    /* AGRUPADOR PR‡PRIO*/), com id-agrupador igual ao id-etiqueta gerado. 
    Consiste os dados passados na ttWm-etiqueta, porque trata-se de um item 
    normal, com a diferenáa que o agrupador Ç o pr¢prio item.
    
    Este mÇtodo foi gerado a partir do geraEtiquetaItemUnico, um vez que houve uma 
    necessidade espec°fica e n∆o era interessante uma alteraá∆o nas transaá‰es j† 
    existentes do coletor. Gera a etiqueta "N«O LIDA"
    
------------------------------------------------------------------------------*/
    
    DEF INPUT  PARAM TABLE FOR ttWm-etiqueta.     /* Matriz da etiqueta a ser gerada    */
    DEF OUTPUT PARAM pSerialAgrup AS DECIMAL.     /* Serial do Item/Agrupador           */


    DEF VAR c-valor AS CHAR NO-UNDO.

    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    
    FIND FIRST ttWm-etiqueta NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ttWm-etiqueta THEN RETURN "NOK".
    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    IF ttWm-etiqueta.Cod-cliente = 0 THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Cliente":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-cliente = INTEGER(c-valor).
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel = c-valor.
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel-ord) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-ord = c-valor.
    END.

    IF TRIM(ttWm-etiqueta.Cod-estabel-pedido) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-pedido = c-valor.
    END.
    
    
    IF TRIM(ttWm-etiqueta.Cod-embalagem) <> "":U THEN DO:

        FIND FIRST wm-embalagem WHERE
            wm-embalagem.cod-embalagem = RowObject.cod-embalagem NO-LOCK NO-ERROR.
            
        IF NOT AVAIL wm-embalagem THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embalagem-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-embalagem-2"}
            RETURN "NOK":U.
        END.
        
    END.

    IF TRIM(ttWm-etiqueta.Cod-embalagem) = "":U THEN DO:
        FIND FIRST wm-local
             WHERE wm-local.cod-estabel      = ttWm-etiqueta.cod-estabel AND
                   wm-local.log-local-padrao = YES NO-LOCK NO-ERROR.

        /* Se existir embalagem item local padr∆o para o item */
        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = ttWm-etiqueta.cod-estabel AND
                   wm-item-embalagem-local.cod-local   = wm-local.cod-local        AND
                   wm-item-embalagem-local.cod-item    = ttWm-etiqueta.Cod-item    AND
                   wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.

        IF AVAIL wm-item-embalagem-local THEN
            ASSIGN ttWm-etiqueta.cod-embalagem = wm-item-embalagem-local.cod-embalagem.
        ELSE DO:
            /* Caso n∆o exista embalagem item local padr∆o para o item, pega dos parÉmetros do WMS */
            RUN getInfoPadrao IN hDBOWm-Param (INPUT "embalagem":U, OUTPUT c-valor).
            ASSIGN ttWm-etiqueta.cod-embalagem = c-valor.

            FIND FIRST wm-embalagem 
                 WHERE wm-embalagem.cod-embalagem   = c-valor NO-LOCK NO-ERROR.

            CREATE wm-item-embalagem-local.
            ASSIGN wm-item-embalagem-local.cod-estabel        = ttWm-etiqueta.cod-estabel
                   wm-item-embalagem-local.cod-local          = wm-local.cod-local
                   wm-item-embalagem-local.cod-embalagem      = c-valor
                   wm-item-embalagem-local.cod-item           = ttWm-etiqueta.Cod-item
                   wm-item-embalagem-local.log-abre-embalagem = NO
                   wm-item-embalagem-local.log-padrao         = YES
                   wm-item-embalagem-local.qtd-item-emb       = 1
                   wm-item-embalagem-local.qtd-min-item-emb   = 0
                   wm-item-embalagem-local.qtd-peso           = wm-embalagem.qtd-peso
                   wm-item-embalagem-local.qtd-volume         = wm-embalagem.qtd-altura * wm-embalagem.qtd-comprimento * wm-embalagem.qtd-largura.
        END.
    END.
    
    CREATE RowObject.
    ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
           RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
           RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
           RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
           RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
           RowObject.cod-item             = ttWm-etiqueta.Cod-item
           RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
           RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
           RowObject.dt-geracao           = ttWm-etiqueta.Dt-geracao
           RowObject.dt-leitura           = TODAY
           RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
           RowObject.hr-geracao           = ttWm-etiqueta.Hr-geracao
           RowObject.ind-leitura-etiqueta = 2    /*    LIDA       */
           RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
           RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
           RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
           RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
           RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
           RowObject.ind-sit-agrupador    = 3    /* AGRUPADOR PR‡PRIO */.
           

    RUN EmptyRowErrors IN THIS-PROCEDURE.
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK".
    END.
    
    
    /* Gera um serial de etiqueta */    
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerial, INPUT 1).

    /* N∆o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
             
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).        
        
    FOR EACH ttSerial:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.
        
        CREATE RowObject.
        ASSIGN pSerialAgrup                   = ttSerial.de-serial
               RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
               RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
               RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
               RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
               RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
               RowObject.cod-item             = ttWm-etiqueta.Cod-item
               RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
               RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY 
               RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
               RowObject.hr-geracao           = TIME  
               RowObject.ind-leitura-etiqueta = 1    /* N«O LIDA       */
               RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
               RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
               RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
               RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev           
               RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
               RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
               RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
               RowObject.id-agrupador         = pSerialAgrup
               RowObject.id-etiqueta          = pSerialAgrup
               RowObject.id-carga             = 0
               RowObject.ind-sit-agrupador    = 3    /* AGRUPADOR PR‡PRIO */
/*               RowObject.log-impressa         = YES  /* Em princ°pio, toda etiqueta solicitada pelo coletor ter† este status */ */
               RowObject.log-impressa         = ttWm-etiqueta.log-impressa
               RowObject.log-reportada        = NO.

               
               
        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetas DBOProgram 
PROCEDURE geraEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  A partir deste mÇtodo Ç poss°vel gerar uma ou mais etiquetas de itens. 
  Na ttWm-etiqueta Ç passado apenas 1 (um)  registro contendo os dados que dever∆o 
  serem utilizados no registro de etiquetas.  Retorna uma temp-table 
  contendo os seriais das etiquetas gerados.  ind-sit-agrupador = 1    /* N«O AGRUPA */

  Obs.: o status "Lida" / "N∆o lida" Ç definido na ttWm-etiqueta.

  ind-leitura-etiqueta = 1 - N∆o lido
                         2 - Lido
                         3 - Inutilizado
                         4 - Estornado
                         
  ind-sit-agrupador    = 1 - N∆o agrupa           (caso de itens normais)
                         2 - Agrupados etiquetas  (Pallets)
                         3 - Agrupador pr¢prio    (caso de itens que ocupam 100% do pallet)
  
  
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM TABLE FOR ttWm-etiqueta.     /* dados da etiqueta a ser gerada (matriz)           */
    DEF INPUT  PARAM pQtdEtiqueta  AS INTEGER.    /* Quantidade de etiquetas (seriais) a serem geradas */
    DEF OUTPUT PARAM TABLE FOR ttSerial.          /* Temp-table com o(s) serial(ais) gerado(s)         */

    DEF VAR c-valor AS CHAR NO-UNDO.

    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    
    FIND FIRST ttWm-etiqueta NO-ERROR.
    
    IF NOT AVAIL ttWm-etiqueta THEN RETURN "NOK".
    
    IF ttWm-etiqueta.ind-sit-agrupador < 1 AND ttWm-etiqueta.ind-sit-agrupador > 3 THEN DO:
        ASSIGN ttWm-etiqueta.ind-sit-agrupador = 1.
    END.

    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel = c-valor.
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel-ord) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-ord = c-valor.
    END.

    IF TRIM(ttWm-etiqueta.Cod-estabel-pedido) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-pedido = c-valor.
    END.
    
    IF NOT CAN-FIND(FIRST wm-embalagem 
    WHERE wm-embalagem.cod-embalagem = ttWm-etiqueta.cod-embalagem NO-LOCK) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem" *}
        ASSIGN c-lbl-liter-embalagem-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-3"}
        RETURN "NOK":U.
    END.   
        
    IF TRIM(ttWm-etiqueta.Cod-embalagem) = "":U THEN DO:

        FIND FIRST wm-local
             WHERE wm-local.cod-estabel      = ttWm-etiqueta.cod-estabel AND
                   wm-local.log-local-padrao = YES NO-LOCK NO-ERROR.

        /* Se existir embalagem item local padr∆o para o item */
        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = ttWm-etiqueta.cod-estabel AND
                   wm-item-embalagem-local.cod-local   = wm-local.cod-local        AND
                   wm-item-embalagem-local.cod-item    = ttWm-etiqueta.Cod-item    AND
                   wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.

            
        IF AVAIL wm-item-embalagem-local THEN
            ASSIGN ttWm-etiqueta.cod-embalagem = wm-item-embalagem-local.cod-embalagem.
        ELSE DO:   
            /* Caso n∆o exista embalagem item local padr∆o para o item, pega dos parÉmetros do WMS */
            RUN getInfoPadrao IN hDBOWm-Param (INPUT "embalagem":U, OUTPUT c-valor).
            ASSIGN ttWm-etiqueta.cod-embalagem = c-valor.
                        
            FIND FIRST wm-embalagem 
                 WHERE wm-embalagem.cod-embalagem   = c-valor NO-LOCK NO-ERROR.
        
            CREATE wm-item-embalagem-local.
            ASSIGN wm-item-embalagem-local.cod-estabel        = ttWm-etiqueta.cod-estabel
                   wm-item-embalagem-local.cod-local          = wm-local.cod-local
                   wm-item-embalagem-local.cod-embalagem      = c-valor
                   wm-item-embalagem-local.cod-item           = ttWm-etiqueta.Cod-item
                   wm-item-embalagem-local.log-abre-embalagem = NO
                   wm-item-embalagem-local.log-padrao         = YES
                   wm-item-embalagem-local.qtd-item-emb       = 1
                   wm-item-embalagem-local.qtd-min-item-emb   = 0
                   wm-item-embalagem-local.qtd-peso           = wm-embalagem.qtd-peso
                   wm-item-embalagem-local.qtd-volume         = wm-embalagem.qtd-altura * wm-embalagem.qtd-comprimento * wm-embalagem.qtd-largura.
        END.        
    END.    
    
    CREATE RowObject.
    ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
           RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
           RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
           RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
           RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
           RowObject.cod-item             = ttWm-etiqueta.Cod-item
           RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
           RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
           RowObject.dt-geracao           = ttWm-etiqueta.Dt-geracao
           RowObject.dt-leitura           = ttWm-etiqueta.Dt-leitura
           RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
           RowObject.hr-geracao           = ttWm-etiqueta.Hr-geracao
           RowObject.ind-leitura-etiqueta = ttWm-etiqueta.Ind-leitura-etiqueta
           RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
           RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
           RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
           RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
           RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
           RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
           RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev
           RowObject.ind-sit-agrupador    = ttWm-etiqueta.ind-sit-agrupador.
           
    RUN EmptyRowErrors IN THIS-PROCEDURE.
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).    
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK".
    END.    
    
    /* Gera um serial de etiqueta */    
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerial, INPUT pQtdEtiqueta).
        
    /* N∆o gerou nenhum registro */    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
             
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).        
        
    FOR EACH ttSerial:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.

        CREATE RowObject.
        ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
               RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
               RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
               RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
               RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
               RowObject.cod-item             = ttWm-etiqueta.Cod-item
               RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
               RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY 
               RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
               RowObject.hr-geracao           = TIME
               RowObject.id-etiqueta          = ttSerial.de-serial
               RowObject.ind-leitura-etiqueta = ttWm-etiqueta.Ind-leitura-etiqueta    /* LIDA/N«O LIDA */
               RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
               RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
               RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
               RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
               RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
               RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev
               RowObject.id-agrupador         = 0
               RowObject.id-carga             = 0
               RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
               RowObject.ind-sit-agrupador    = ttWm-etiqueta.ind-sit-agrupador 
             /*RowObject.log-impressa         = YES  /* Em princ°pio, toda etiqueta solicitada pelo coletor ter† este status */ */ 
               RowObject.log-impressa         = ttWm-etiqueta.log-impressa
               RowObject.log-reportada        = ttWm-etiqueta.log-reportada.           

        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetasWMS DBOProgram 
PROCEDURE geraEtiquetasWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  A partir deste mÇtodo Ç poss°vel gerar uma ou mais etiquetas de itens. 
  Na ttWm-etiqueta Ç passado apenas 1 (um)  registro contendo os dados que dever∆o 
  serem utilizados no registro de etiquetas.  Retorna uma temp-table 
  contendo os seriais das etiquetas gerados.  ind-sit-agrupador = 1    /* N«O AGRUPA */

  Obs.: o status "Lida" / "N∆o lida" Ç definido na ttWm-etiqueta.

  ind-leitura-etiqueta = 1 - N∆o lido
                         2 - Lido
                         3 - Inutilizado
                         4 - Estornado
                         
  ind-sit-agrupador    = 1 - N∆o agrupa           (caso de itens normais)
                         2 - Agrupados etiquetas  (Pallets)
                         3 - Agrupador pr¢prio    (caso de itens que ocupam 100% do pallet)
  
  
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM TABLE FOR ttWm-etiqueta.     /* dados da etiqueta a ser gerada (matriz)           */
    DEF INPUT  PARAM pQtdEtiqueta  AS INTEGER.    /* Quantidade de etiquetas (seriais) a serem geradas */
    DEF INPUT  PARAM deSerial      AS DECIMAL.          /* Temp-table com o(s) serial(ais) gerado(s)         */

    DEF VAR c-valor AS CHAR NO-UNDO.


    FIND FIRST ttWm-etiqueta NO-ERROR.
    
    IF NOT AVAIL ttWm-etiqueta THEN RETURN "NOK".
    
    IF ttWm-etiqueta.ind-sit-agrupador < 1 AND ttWm-etiqueta.ind-sit-agrupador > 3 THEN DO:
        ASSIGN ttWm-etiqueta.ind-sit-agrupador = 1.
    END.

    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel = c-valor.
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-estabel-ord) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-ord = c-valor.
    END.

    IF TRIM(ttWm-etiqueta.Cod-estabel-pedido) = "":U THEN DO:
        RUN getInfoPadrao IN hDBOWm-Param (INPUT "Estabelecimento":U, OUTPUT c-valor).
        ASSIGN ttWm-etiqueta.cod-estabel-pedido = c-valor.
    END.
    
    IF NOT CAN-FIND(FIRST wm-embalagem 
    WHERE wm-embalagem.cod-embalagem = ttWm-etiqueta.cod-embalagem NO-LOCK) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem" *}
        ASSIGN c-lbl-liter-embalagem-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-3"}
        RETURN "NOK":U.
    END.
    
    IF TRIM(ttWm-etiqueta.Cod-embalagem) = "":U THEN DO:

        FIND FIRST wm-local
             WHERE wm-local.cod-estabel      = ttWm-etiqueta.cod-estabel AND
                   wm-local.log-local-padrao = YES NO-LOCK NO-ERROR.

        /* Se existir embalagem item local padr∆o para o item */
        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = ttWm-etiqueta.cod-estabel AND
                   wm-item-embalagem-local.cod-local   = wm-local.cod-local        AND
                   wm-item-embalagem-local.cod-item    = ttWm-etiqueta.Cod-item    AND
                   wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.
            
        IF AVAIL wm-item-embalagem-local THEN
            ASSIGN ttWm-etiqueta.cod-embalagem = wm-item-embalagem-local.cod-embalagem.
        ELSE DO:   
            /* Caso n∆o exista embalagem item local padr∆o para o item, pega dos parÉmetros do WMS */
            RUN getInfoPadrao IN hDBOWm-Param (INPUT "embalagem":U, OUTPUT c-valor).
            ASSIGN ttWm-etiqueta.cod-embalagem = c-valor.
                        
            FIND FIRST wm-embalagem 
                 WHERE wm-embalagem.cod-embalagem   = c-valor NO-LOCK NO-ERROR.
        
            CREATE wm-item-embalagem-local.
            ASSIGN wm-item-embalagem-local.cod-estabel        = ttWm-etiqueta.cod-estabel
                   wm-item-embalagem-local.cod-local          = wm-local.cod-local
                   wm-item-embalagem-local.cod-embalagem      = c-valor
                   wm-item-embalagem-local.cod-item           = ttWm-etiqueta.Cod-item
                   wm-item-embalagem-local.log-abre-embalagem = NO
                   wm-item-embalagem-local.log-padrao         = YES
                   wm-item-embalagem-local.qtd-item-emb       = 1
                   wm-item-embalagem-local.qtd-min-item-emb   = 0
                   wm-item-embalagem-local.qtd-peso           = wm-embalagem.qtd-peso
                   wm-item-embalagem-local.qtd-volume         = wm-embalagem.qtd-altura * wm-embalagem.qtd-comprimento * wm-embalagem.qtd-largura.
        END.        
    END.

    CREATE RowObject.
    ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
           RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
           RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
           RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
           RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
           RowObject.cod-item             = ttWm-etiqueta.Cod-item
           RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
           RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
           RowObject.dt-geracao           = ttWm-etiqueta.Dt-geracao
           RowObject.dt-leitura           = ttWm-etiqueta.Dt-leitura
           RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
           RowObject.hr-geracao           = ttWm-etiqueta.Hr-geracao
           RowObject.ind-leitura-etiqueta = ttWm-etiqueta.Ind-leitura-etiqueta
           RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
           RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
           RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
           RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
           RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
           RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
           RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev
           RowObject.ind-sit-agrupador    = ttWm-etiqueta.ind-sit-agrupador.
           
    RUN EmptyRowErrors IN THIS-PROCEDURE.
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK".
    END.
      
        
    IF deSerial <> 0 THEN DO:
    
        FOR EACH RowObject:
            DELETE RowObject.
        END.

        CREATE RowObject.
        ASSIGN RowObject.cod-cliente          = ttWm-etiqueta.Cod-cliente
               RowObject.cod-embalagem        = ttWm-etiqueta.Cod-embalagem
               RowObject.cod-estabel          = ttWm-etiqueta.Cod-estabel
               RowObject.cod-estabel-ord      = ttWm-etiqueta.Cod-estabel-ord
               RowObject.cod-estabel-pedido   = ttWm-etiqueta.Cod-estabel-pedido
               RowObject.cod-item             = ttWm-etiqueta.Cod-item
               RowObject.cod-lote             = ttWm-etiqueta.Cod-lote
               RowObject.cod-refer            = ttWm-etiqueta.Cod-refer
               RowObject.dt-geracao           = TODAY
               RowObject.dt-leitura           = TODAY 
               RowObject.dt-validade-lote     = ttWm-etiqueta.Dt-validade-lote
               RowObject.hr-geracao           = TIME
               RowObject.id-etiqueta          = deSerial
               RowObject.ind-leitura-etiqueta = ttWm-etiqueta.Ind-leitura-etiqueta    /* LIDA/N«O LIDA */
               RowObject.nr-ord-prod          = ttWm-etiqueta.Nr-ord-prod
               RowObject.nr-pedido            = ttWm-etiqueta.Nr-pedido
               RowObject.qtd-item             = ttWm-etiqueta.Qtd-item
               RowObject.qtd-peso             = ttWm-etiqueta.Qtd-peso
               RowObject.nr-pedcli            = ttWm-etiqueta.nr-pedcli
               RowObject.nome-abrev           = ttWm-etiqueta.nome-abrev
               RowObject.id-agrupador         = 0
               RowObject.id-carga             = 0
               RowObject.cod-usuario          = ttWm-etiqueta.Cod-usuario
               RowObject.ind-sit-agrupador    = ttWm-etiqueta.ind-sit-agrupador 
             /*RowObject.log-impressa         = YES  /* Em princ°pio, toda etiqueta solicitada pelo coletor ter† este status */ */ 
               RowObject.log-impressa         = ttWm-etiqueta.log-impressa
               RowObject.log-reportada        = ttWm-etiqueta.log-reportada.           

        RUN setRecord    IN THIS-PROCEDURE(INPUT TABLE RowObject).
        RUN createRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE RowErrors).
        
    END.
    
    FOR EACH ttRowErrors:
        CREATE RowErrors.
        BUFFER-COPY ttRowErrors TO RowErrors.
    END.
    
    IF CAN-FIND(FIRST RowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
    
    RUN DESTROY IN hDBOWm-Param.    

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetasItemAvulsoRep DBOProgram 
PROCEDURE geraEtiquetasItemAvulsoRep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM TABLE FOR ttWm-etiqueta.     /* dados da etiqueta a ser gerada (matriz)           */
    DEF INPUT  PARAM pQtdEtiqueta  AS INTEGER.    /* Quantidade de etiquetas (seriais) a serem geradas */
    DEF OUTPUT PARAM TABLE FOR ttSerial.          /* Temp-table com o(s) serial(ais) gerado(s)         */
    DEF OUTPUT PARAM pIdAgrupador LIKE wm-etiqueta.id-agrupador NO-UNDO.


    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    
    
    DO ON ERROR UNDO, RETURN "NOK":U :
    
        RUN geraEtiquetas IN THIS-PROCEDURE (INPUT  TABLE ttWm-etiqueta,
                                            INPUT  pQtdEtiqueta,
                                            OUTPUT TABLE ttSerial).
        
        IF RETURN-VALUE = "NOK":U THEN UNDO, RETURN "NOK":U.
        
        FOR EACH ttSerial:
            
            FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL wm-etiqueta THEN DO:
                
                ASSIGN wm-etiqueta.log-reportada = YES.
                RELEASE wm-etiqueta.
            END.
            
        END.
        
        FIND FIRST ttWm-etiqueta NO-LOCK NO-ERROR.
        
        RUN geraAgrupEtiquetaLida IN THIS-PROCEDURE (INPUT ttWm-etiqueta.cod-usuario,
                                                     INPUT TABLE ttSerial,
                                                     OUTPUT pIdAgrupador).
        
        IF RETURN-VALUE = "NOK":U THEN UNDO, RETURN "NOK":U.
        
        FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = pIdAgrupador EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL wm-etiqueta THEN DO:
            
            ASSIGN wm-etiqueta.log-reportada = YES.
            RELEASE wm-etiqueta.
        END.
    
    
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraLogMultiplanta DBOProgram 
PROCEDURE geraLogMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-nr-docum        as char no-undo.
def input param c-cod-estabel-doc as char no-undo.
def input param c-nr-serie        as char no-undo.
def input-output param table for tt-mensagem.

FIND FIRST wm-docto WHERE
     wm-docto.cod-estabel = c-cod-estabel-doc AND
     wm-docto.num-docto   = c-nr-docum        AND
     wm-docto.serie       = c-nr-serie
     NO-LOCK NO-ERROR.
IF AVAIL wm-docto THEN DO:
    FIND wm-carga where
         wm-carga.id-carga = wm-docto.id-carga
         NO-LOCK NO-ERROR.
    IF AVAIL wm-carga THEN
    for each wm-etiqueta where
        wm-etiqueta.id-carga    = wm-carga.id-carga no-lock:
    
        create tt-mensagem.
        assign substring(tt-mensagem.mensagem[1],01,01) = "E":U              
               substring(tt-mensagem.mensagem[1],02,15) = string(wm-etiqueta.id-etiqueta)
               &IF "{&mguni_version}" < "2.071" &THEN
                substring(tt-mensagem.mensagem[1],17,03) = string(wm-etiqueta.cod-estabel)
               &ENDIF
               substring(tt-mensagem.mensagem[1],20,16) = string(wm-etiqueta.cod-item)
               substring(tt-mensagem.mensagem[1],36,08) = string(wm-etiqueta.cod-refer)
               substring(tt-mensagem.mensagem[1],44,40) = string(wm-etiqueta.cod-lote)
               substring(tt-mensagem.mensagem[1],84,10) = string(wm-etiqueta.dt-validade-lote)
               substring(tt-mensagem.mensagem[1],94,02) = string(wm-etiqueta.ind-leitura-etiqueta)
               &IF "{&mguni_version}" >= "2.071" &THEN
                substring(tt-mensagem.mensagem[1],96,05) = string(wm-etiqueta.cod-estabel)
               &ENDIF
               substring(tt-mensagem.mensagem[2],01,16) = string(wm-etiqueta.qtd-item)
               substring(tt-mensagem.mensagem[2],17,14) = string(wm-etiqueta.qtd-peso)                       
               substring(tt-mensagem.mensagem[2],31,09) = string(wm-etiqueta.cod-cliente)
               substring(tt-mensagem.mensagem[2],40,10) = string(wm-etiqueta.cod-embalagem)
               substring(tt-mensagem.mensagem[2],50,11) = string(wm-etiqueta.nr-pedido)
               &IF "{&mguni_version}" < "2.071" &THEN
                substring(tt-mensagem.mensagem[2],61,03) = string(wm-etiqueta.cod-estabel-pedido)
               &ELSE
                substring(tt-mensagem.mensagem[2],61,05) = string(wm-etiqueta.cod-estabel-pedido)
               &ENDIF
               substring(tt-mensagem.mensagem[3],01,11) = string(wm-etiqueta.nr-ord-prod)
               &IF "{&mguni_version}" < "2.071" &THEN
               substring(tt-mensagem.mensagem[3],12,03) = string(wm-etiqueta.cod-estabel-ord)
               &ENDIF
               substring(tt-mensagem.mensagem[3],15,10) = string(wm-etiqueta.dt-geracao)
               substring(tt-mensagem.mensagem[3],25,05) = string(wm-etiqueta.hr-geracao)
               substring(tt-mensagem.mensagem[3],30,10) = string(wm-etiqueta.dt-leitura)
               substring(tt-mensagem.mensagem[3],40,12) = string(wm-etiqueta.cod-usuario)
               substring(tt-mensagem.mensagem[3],52,14) = string(wm-etiqueta.id-agrupador)
               substring(tt-mensagem.mensagem[3],66,02) = string(wm-etiqueta.ind-sit-agrupador)
               &IF "{&mguni_version}" >= "2.071" &THEN
                substring(tt-mensagem.mensagem[3],68,05) = string(wm-etiqueta.cod-estabel-ord)
               &ENDIF
               substring(tt-mensagem.mensagem[4],01,14) = string(wm-etiqueta.id-carga)
               substring(tt-mensagem.mensagem[4],15,01) = if wm-etiqueta.log-impressa  = yes then "1" else "0"
               substring(tt-mensagem.mensagem[4],16,01) = if wm-etiqueta.log-reportada = yes then "1" else "0"
               substring(tt-mensagem.mensagem[4],17,02) = string(wm-etiqueta.ind-sit-estorno)
               substring(tt-mensagem.mensagem[4],19,12) = string(wm-etiqueta.nome-abrev)               
               substring(tt-mensagem.mensagem[4],31,12) = string(wm-etiqueta.nr-pedcli)               
               tt-mensagem.int-1                        = wm-etiqueta.int-1
               tt-mensagem.log-1                        = wm-etiqueta.log-1
               tt-mensagem.char-1                       = wm-etiqueta.char-1
               tt-mensagem.dec-1                        = wm-etiqueta.dec-1.   
        
    end.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraSeqEtiqueta DBOProgram 
PROCEDURE geraSeqEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em gerar, apartir do BO de etiquetas, um novo n£mero serial 
  v†lido no BO de parÉmetros.
  
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM pSerial AS DECIMAL.

    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-param) THEN
        RUN scbo/bosc050.p PERSISTENT SET hDBOWm-param.
    
    /* Gera um serial de etiqueta */    
    RUN geraSeqEtiqueta IN hDBOWm-Param (OUTPUT TABLE ttSerial, INPUT 1).

    /* N∆o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hDBOWm-Param.
        RETURN "NOK":U.
    END.
             
    RUN GetRowErrors IN hDBOWm-Param (OUTPUT TABLE ttRowErrors).    

    FIND FIRST ttSerial NO-LOCK NO-ERROR.
    
    IF AVAIL ttSerial THEN 
        ASSIGN pSerial = ttSerial.de-serial.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCarga DBOProgram 
PROCEDURE getCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estabel LIKE wm-conferencia.cod-estabel NO-UNDO.
DEF INPUT  PARAM p-cod-local   LIKE wm-conferencia.cod-local NO-UNDO.
DEF INPUT  PARAM p-id-docto    LIKE wm-conferencia.id-docto NO-UNDO.
DEF OUTPUT PARAM p-id-carga    LIKE wm-carga.id-carga NO-UNDO.

def var i-id-carga-aux like wm-carga.id-carga no-undo.

FIND FIRST wm-docto WHERE
    wm-docto.cod-estabel = p-cod-estabel AND
    wm-docto.cod-local   = p-cod-local   AND
    wm-docto.id-docto    = p-id-docto NO-LOCK NO-ERROR.
    
IF AVAIL wm-docto THEN DO:
    FIND FIRST wm-carga WHERE
         wm-carga.id-carga = wm-docto.id-carga 
         NO-LOCK NO-ERROR.
    ASSIGN p-id-carga = IF AVAIL wm-carga THEN wm-carga.id-carga 
                                          ELSE 0.
END.
ELSE
    ASSIGN p-id-carga = 0.    

RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-embalagem":U THEN ASSIGN pFieldValue = RowObject.cod-embalagem.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-estabel-ord":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-ord.
        WHEN "cod-estabel-pedido":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-pedido.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-lote":U THEN ASSIGN pFieldValue = RowObject.cod-lote.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getConteudoCarga DBOProgram 
PROCEDURE getConteudoCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em apresentar todas as etiquetas (n∆o agrupa, agrupador 
  etiquetas, agrupador pr¢prio)  vinculadas a uma determinada carga em 
  espec°fico. necess†rio na apresentaá∆o dos dados ficar atento ao n°vel que existe entre 
  etiquetas agrupadoras e etiquetas n∆o agrupadoras.
    
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pIdCarga     AS DECIMAL.
    DEF INPUT  PARAM pLnaoAgrupa  AS LOGICAL.
    DEF INPUT  PARAM pLagrupa     AS LOGICAL.
    DEF INPUT  PARAM pLproprio    AS LOGICAL.
    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta. 
    
    FOR EACH ttWm-etiqueta:
        DELETE ttWm-etiqueta.
    END.
    
    
    FOR EACH wm-etiqueta
        WHERE 
        wm-etiqueta.id-carga          = pIdCarga  AND
        ((wm-etiqueta.ind-sit-agrupador = 1 AND pLnaoAgrupa = yes) OR           /* S¢ de pallet      */
         (wm-etiqueta.ind-sit-agrupador = 2 AND pLagrupa    = yes) OR
         (wm-etiqueta.ind-sit-agrupador = 3 AND pLproprio   = yes))
        NO-LOCK:
        
        DO TRANSACTION:
            CREATE ttWm-etiqueta.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta.
        END.    
        
    END.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-geracao":U THEN ASSIGN pFieldValue = RowObject.dt-geracao.
        WHEN "dt-leitura":U THEN ASSIGN pFieldValue = RowObject.dt-leitura.
        WHEN "dt-validade-lote":U THEN ASSIGN pFieldValue = RowObject.dt-validade-lote.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "id-etiqueta":U THEN ASSIGN pFieldValue = RowObject.id-etiqueta.
        WHEN "qtd-item":U THEN ASSIGN pFieldValue = RowObject.qtd-item.
        WHEN "qtd-peso":U THEN ASSIGN pFieldValue = RowObject.qtd-peso.
        WHEN "id-agrupador":U THEN ASSIGN pFieldValue = RowObject.id-agrupador.
        WHEN "id-carga":U THEN ASSIGN pFieldValue = RowObject.id-carga.
        WHEN "qtd-item-retirado":U THEN ASSIGN pFieldValue = RowObject.qtd-item-retirado.
     /*   WHEN "cdd-etiq-origin":U THEN ASSIGN pFieldValue = RowObject.cdd-etiq-origin.*/
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFK DBOProgram 
PROCEDURE getDescFK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT  PARAM c-table       AS CHAR NO-UNDO.
  DEF INPUT  PARAM c-param       AS CHAR NO-UNDO.
  DEF INPUT  PARAM c-param2      AS CHAR NO-UNDO.
  DEF OUTPUT PARAM c-description AS CHAR NO-UNDO.

  CASE c-table:
      WHEN "Wm-Estabel":U THEN DO:
          FIND FIRST Wm-Estabel WHERE Wm-Estabel.cod-estabel = c-param NO-LOCK NO-ERROR.
          IF AVAIL Wm-Estabel THEN
              ASSIGN c-description = Wm-Estabel.nom-estabel.
          ELSE
              ASSIGN c-description = " ":U.
      END.
      WHEN "Wm-cliente":U THEN DO:
          FIND FIRST Wm-cliente WHERE Wm-cliente.cod-cliente = INTEGER(c-param) NO-LOCK NO-ERROR.
          IF AVAIL Wm-cliente THEN
              ASSIGN c-description = Wm-cliente.nome-abrev.
          ELSE
              ASSIGN c-description = " ":U.      
      END.      
      WHEN "Wm-embalagem":U THEN DO:
          FIND FIRST Wm-embalagem WHERE Wm-embalagem.cod-embalagem = c-param NO-LOCK NO-ERROR.
          IF AVAIL Wm-embalagem THEN
              ASSIGN c-description = Wm-embalagem.des-embalagem.
          ELSE
              ASSIGN c-description = " ":U.      
      END.      
      WHEN "Wm-referencia":U THEN DO:
          FIND FIRST Wm-referencia WHERE Wm-referencia.cod-refer = c-param NO-LOCK NO-ERROR.
          IF AVAIL Wm-referencia THEN
              ASSIGN c-description = Wm-referencia.des-refer.
          ELSE
              ASSIGN c-description = " ":U.      
      END.      
      WHEN "Wm-ref-item":U THEN DO:
          FIND FIRST Wm-ref-item WHERE 
              Wm-ref-item.cod-refer = c-param  AND
              Wm-ref-item.cod-item  = c-param2 
              NO-LOCK NO-ERROR.
          
          IF AVAIL wm-ref-item THEN DO:
              FIND FIRST Wm-referencia WHERE Wm-referencia.cod-refer = c-param NO-LOCK NO-ERROR.
              IF AVAIL Wm-referencia THEN
                  ASSIGN c-description = Wm-referencia.des-refer.
              ELSE
                  ASSIGN c-description = " ":U.
          END.
          ELSE                        
              ASSIGN c-description = " ":U.  
      END.      
      WHEN "Wm-item":U THEN DO:
          FIND FIRST Wm-item WHERE Wm-item.cod-item = c-param NO-LOCK NO-ERROR.
          IF AVAIL Wm-item THEN
              ASSIGN c-description = Wm-item.des-item.
          ELSE
              ASSIGN c-description = " ":U.      
      END.      
  END CASE.    

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEtiquetaDoctoRE DBOProgram 
PROCEDURE getEtiquetaDoctoRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estabel      LIKE wm-docto.cod-estabel   NO-UNDO.
DEF INPUT  PARAM p-cod-local        LIKE wm-docto.cod-local     NO-UNDO.
DEF INPUT  PARAM p-num-docto        LIKE wm-docto.num-docto     NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-imp-etiqueta.
 
DEF VAR d-qtd-embalar               LIKE wm-docto-itens.qtd-item NO-UNDO.
 
FOR EACH wm-docto WHERE
    wm-docto.cod-estabel      = p-cod-estabel AND
    wm-docto.cod-local        = p-cod-local   AND
    wm-docto.num-docto        = p-num-docto   AND
    (wm-docto.ind-origem-docto = 3 OR  
     wm-docto.ind-origem-docto = 1 OR
     wm-docto.ind-origem-docto = 7) NO-LOCK:
 
    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:
 
        ASSIGN d-qtd-embalar = wm-docto-itens.qtd-item.
 
        FIND FIRST wm-item-embalagem-local WHERE
            wm-item-embalagem-local.cod-estabel = wm-docto.cod-estabel    AND
            wm-item-embalagem-local.cod-local   = wm-docto.cod-local      AND
            wm-item-embalagem-local.cod-item    = wm-docto-itens.cod-item AND
            wm-item-embalagem-local.log-padrao  = YES                     NO-LOCK NO-ERROR.
        IF NOT AVAIL wm-item-embalagem-local THEN
            NEXT.
 
        IF d-qtd-embalar >= wm-item-embalagem-local.qtd-item-emb THEN DO:
            CREATE tt-imp-etiqueta.
            ASSIGN tt-imp-etiqueta.cod-item         = wm-docto-itens.cod-item
                   tt-imp-etiqueta.cod-refer        = wm-docto-itens.cod-refer
                   tt-imp-etiqueta.cod-lote         = wm-docto-itens.cod-lote
                   tt-imp-etiqueta.cod-embalagem    = wm-item-embalagem-local.cod-embalagem
                   tt-imp-etiqueta.cod-emb-item     = wm-item-embalagem-local.cod-emb-item
                   tt-imp-etiqueta.dt-validade-lote = wm-docto-itens.dt-validade-lote
                   tt-imp-etiqueta.tot-qt-pallet    = IF wm-item-embalagem-local.cod-emb-item <> "" THEN TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-item-emb,0) ELSE 0
                   tt-imp-etiqueta.qt-cx-pallet     = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-item-embalagem-local.qtd-item-emb / wm-item-embalagem-local.qtd-emb-item ELSE 0
                   tt-imp-etiqueta.qt-it-cx         = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-item-embalagem-local.qtd-emb-item ELSE wm-item-embalagem-local.qtd-item-emb
                   tt-imp-etiqueta.qt-peso-cx       = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-item-embalagem-local.qtd-peso-item ELSE wm-item-embalagem-local.qtd-peso 
                   tt-imp-etiqueta.tot-qt-caixa     = IF wm-item-embalagem-local.cod-emb-item <> "" THEN tt-imp-etiqueta.qt-cx-pallet * tt-imp-etiqueta.tot-qt-pallet ELSE TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-item-emb,0) /* IF wm-item-embalagem-local.cod-emb-item <> "" THEN TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-emb-item,0) ELSE TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-item-emb,0) */
                   tt-imp-etiqueta.l-imprime        = YES
                   d-qtd-embalar                    = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-docto-itens.qtd-item - (wm-item-embalagem-local.qtd-item-emb * tt-imp-etiqueta.tot-qt-pallet) ELSE wm-docto-itens.qtd-item - (wm-item-embalagem-local.qtd-item-emb * tt-imp-etiqueta.tot-qt-caixa).
        END.
 
        IF d-qtd-embalar > 0 THEN DO:
            CREATE tt-imp-etiqueta.
            ASSIGN tt-imp-etiqueta.cod-item         = wm-docto-itens.cod-item
                   tt-imp-etiqueta.cod-refer        = wm-docto-itens.cod-refer
                   tt-imp-etiqueta.cod-lote         = wm-docto-itens.cod-lote
                   tt-imp-etiqueta.cod-embalagem    = wm-item-embalagem-local.cod-embalagem
                   tt-imp-etiqueta.cod-emb-item     = wm-item-embalagem-local.cod-emb-item
                   tt-imp-etiqueta.dt-validade-lote = wm-docto-itens.dt-validade-lote
                   tt-imp-etiqueta.tot-qt-caixa     = IF wm-item-embalagem-local.cod-emb-item <> "" THEN IF (d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item) <>  INT(d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item) THEN TRUNCATE(d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item,0) + 1 ELSE TRUNCATE(d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item,0)
                                                                                                    ELSE 1
                   tt-imp-etiqueta.tot-qt-pallet    = IF wm-item-embalagem-local.cod-emb-item <> "" THEN 1 ELSE 0
                   tt-imp-etiqueta.qt-cx-pallet     = IF wm-item-embalagem-local.cod-emb-item <> "" THEN d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item ELSE 0
                   tt-imp-etiqueta.qt-it-cx         = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-item-embalagem-local.qtd-emb-item ELSE d-qtd-embalar
                   tt-imp-etiqueta.qt-peso-cx       = IF wm-item-embalagem-local.cod-emb-item <> "" THEN wm-item-embalagem-local.qtd-peso-item ELSE wm-item-embalagem-local.qtd-peso
                   tt-imp-etiqueta.l-imprime        = YES
                   d-qtd-embalar                    = 0.
            ASSIGN .
        END.
 
    END.
END.
 
RETURN "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEtiquetaOP DBOProgram 
PROCEDURE getEtiquetaOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcod-estabel-ord LIKE {&TableName}.cod-estabel-ord NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-ord-prod     LIKE {&TableName}.nr-ord-prod     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttWm-Etiqueta.

    
    FOR EACH ttWm-Etiqueta:
        DELETE ttWm-Etiqueta.
    END.

    FOR EACH {&TableName} USE-INDEX idx-wm-etiqueta7 NO-LOCK
        WHERE {&TableName}.cod-estabel-ord   = pcod-estabel-ord AND
              {&TableName}.nr-ord-prod       = pnr-ord-prod:
        CREATE ttWm-Etiqueta.
        BUFFER-COPY {&TableName} TO ttWm-Etiqueta.
        
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEtiquetasDoctoRE DBOProgram 
PROCEDURE getEtiquetasDoctoRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estabel      LIKE wm-docto.cod-estabel   NO-UNDO.
DEF INPUT  PARAM p-cod-local        LIKE wm-docto.cod-local     NO-UNDO.
DEF INPUT  PARAM p-num-docto        LIKE wm-docto.num-docto     NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-imp-etiqueta.

DEF VAR d-qtd-embalar               LIKE wm-docto-itens.qtd-item NO-UNDO.

FOR EACH wm-docto WHERE
    wm-docto.cod-estabel      = p-cod-estabel AND
    wm-docto.cod-local        = p-cod-local   AND
    wm-docto.num-docto        = p-num-docto   AND
    (wm-docto.ind-origem-docto = 3 OR  wm-docto.ind-origem-docto = 7) NO-LOCK:

    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:

        ASSIGN d-qtd-embalar = wm-docto-itens.qtd-item.

        FIND FIRST wm-item-embalagem-local WHERE
            wm-item-embalagem-local.cod-estabel = wm-docto.cod-estabel    AND
            wm-item-embalagem-local.cod-local   = wm-docto.cod-local      AND
            wm-item-embalagem-local.cod-item    = wm-docto-itens.cod-item AND
            wm-item-embalagem-local.log-padrao  = YES                     NO-LOCK NO-ERROR.
        IF NOT AVAIL wm-item-embalagem-local THEN
            NEXT.

        IF d-qtd-embalar >= wm-item-embalagem-local.qtd-item-emb THEN DO:
            CREATE tt-imp-etiqueta.
            ASSIGN tt-imp-etiqueta.cod-item         = wm-docto-itens.cod-item
                   tt-imp-etiqueta.cod-refer        = wm-docto-itens.cod-refer
                   tt-imp-etiqueta.cod-lote         = wm-docto-itens.cod-lote
                   tt-imp-etiqueta.cod-embalagem    = wm-item-embalagem-local.cod-embalagem
                   tt-imp-etiqueta.cod-emb-item     = wm-item-embalagem-local.cod-emb-item
                   tt-imp-etiqueta.dt-validade-lote = wm-docto-itens.dt-validade-lote
                   tt-imp-etiqueta.tot-qt-caixa     = TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-emb-item,0)     
                   tt-imp-etiqueta.tot-qt-pallet    = TRUNCATE(wm-docto-itens.qtd-item / wm-item-embalagem-local.qtd-item-emb,0)
                   tt-imp-etiqueta.qt-cx-pallet     = wm-item-embalagem-local.qtd-item-emb / wm-item-embalagem-local.qtd-emb-item
                   tt-imp-etiqueta.qt-it-cx         = wm-item-embalagem-local.qtd-emb-item
                   tt-imp-etiqueta.qt-peso-cx       = wm-item-embalagem-local.qtd-peso-item
                   tt-imp-etiqueta.l-imprime        = YES
                   d-qtd-embalar                    = wm-docto-itens.qtd-item - (wm-item-embalagem-local.qtd-item-emb * tt-imp-etiqueta.tot-qt-pallet).
        END.

        IF d-qtd-embalar > 0 AND AVAIL tt-imp-etiqueta THEN DO:
            ASSIGN tt-imp-etiqueta.tot-qt-caixa     = tt-imp-etiqueta.tot-qt-caixa + IF (d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item) <>  INT(d-qtd-embalar / wm-item-embalagem-local.qtd-emb-item) THEN 1 ELSE 0
                   tt-imp-etiqueta.tot-qt-pallet    = tt-imp-etiqueta.tot-qt-pallet + 1.
        END.

    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHabilitaLote DBOProgram 
PROCEDURE getHabilitaLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pCodItem  LIKE wm-etiqueta.cod-item NO-UNDO.
    DEF OUTPUT PARAM pHabilita AS LOGICAL NO-UNDO.

    FIND FIRST wm-item 
        WHERE wm-item.cod-item = pCodItem NO-LOCK NO-ERROR.

    IF AVAIL wm-item THEN
        ASSIGN pHabilita = (wm-item.ind-tipo-contr-est = 3).  /* Lote */
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHabilitaRefer DBOProgram 
PROCEDURE getHabilitaRefer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pCodItem  LIKE wm-etiqueta.cod-item NO-UNDO.
    DEF OUTPUT PARAM pHabilita AS LOGICAL NO-UNDO.

    FIND FIRST wm-item 
        WHERE wm-item.cod-item = pCodItem NO-LOCK NO-ERROR.

    IF AVAIL wm-item THEN DO:
        IF wm-item.ind-tipo-contr-est = 4 THEN /* Controle Referencia */
            ASSIGN pHabilita = YES.
        ELSE
            ASSIGN pHabilita = NO.
    END.
    ELSE RETURN "NOK":U.
        
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInfoAgrupador DBOProgram 
PROCEDURE getInfoAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
        O metodo consiste em retornar as etiquetas associadas ao agrupador
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pSerial  AS DECIMAL. 
    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta2. 
    DEF VAR l-cdk AS LOG INITIAL NO NO-UNDO.

    FOR EACH ttWm-etiqueta2:
        DELETE ttWm-etiqueta2.
    END.
    
    FOR EACH  in-agrup-etiqueta NO-LOCK
        WHERE in-agrup-etiqueta.id-etiqueta-pai  = pSerial: 
        ASSIGN l-ckd = YES.
        FOR EACH wm-etiqueta  
            WHERE wm-etiqueta.id-etiqueta      = in-agrup-etiqueta.id-etiqueta-filho NO-LOCK :
            CREATE ttWm-etiqueta2.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta2.
        END.    
    END.

    IF  NOT l-ckd THEN
        FOR EACH wm-etiqueta USE-INDEX idx-wm-etiqueta9 
           WHERE wm-etiqueta.id-agrupador      = pSerial AND
                 wm-etiqueta.ind-sit-agrupador = 1       NO-LOCK :
    
            CREATE ttWm-etiqueta2.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta2.
        END.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInfoAgrupadores DBOProgram 
PROCEDURE getInfoAgrupadores :
/*------------------------------------------------------------------------------
  Purpose:     Retornar todos os agrupadores que ainda nao foram associados
               a uma carga
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta2. 
    
    DEF VARIABLE i-cont AS INTEGER NO-UNDO.

    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE ttWm-etiqueta2.
    &ELSE
        FOR EACH ttWm-etiqueta2:
            DELETE ttWm-etiqueta2.
        END.
    &ENDIF    

    DO i-cont = 2 TO 3:   
        FOR EACH  wm-etiqueta USE-INDEX idx-wm-etiqueta5 
            WHERE wm-etiqueta.ind-sit-agrupador = i-cont AND
                  wm-etiqueta.id-carga                 = 0       AND
                  wm-etiqueta.log-reportada          = YES NO-LOCK:
            CREATE ttWm-etiqueta2.
            BUFFER-COPY wm-etiqueta TO ttWm-etiqueta2.
        END.    
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInfoEtiqueta DBOProgram 
PROCEDURE getInfoEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em obter as informaá‰es da etiqueta, atravÇs de um n£mero 
  serial informado.
  
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pSerial  AS DECIMAL. 
    DEF OUTPUT PARAM TABLE FOR ttWm-etiqueta. 

    FIND FIRST wm-etiqueta WHERE 
        wm-etiqueta.id-etiqueta = pSerial NO-LOCK NO-ERROR.

    IF AVAIL wm-etiqueta THEN DO:
    
        FOR EACH ttWm-etiqueta:
            DELETE ttWm-etiqueta.
        END.
        
        CREATE ttWm-etiqueta.
        BUFFER-COPY wm-etiqueta TO ttWm-etiqueta.

    END.    
    ELSE DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-13 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-13 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-13"}
        
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-cliente.
        WHEN "hr-geracao":U THEN ASSIGN pFieldValue = RowObject.hr-geracao.
        WHEN "ind-leitura-etiqueta":U THEN ASSIGN pFieldValue = RowObject.ind-leitura-etiqueta.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-prod":U THEN ASSIGN pFieldValue = RowObject.nr-ord-prod.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "ind-sit-agrupador":U THEN ASSIGN pFieldValue = RowObject.ind-sit-agrupador.
        &IF '{&mgscm_version}' >= '2.06B' &THEN
            &IF '{&mgscm_version}' >= '2.08' &THEN
               WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.int-1. /*Alterar para o campo criado na 2.08 quando o dicionario for liberado*/
            &ELSE 
               WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.int-1.
            &ENDIF
        &ENDIF 
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-wm-etiqueta1
  Parameters:  
               retorna valor do campo id-etiqueta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pid-etiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pid-etiqueta = RowObject.id-etiqueta.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-impressa":U THEN ASSIGN pFieldValue = RowObject.log-impressa.
        WHEN "log-reportada":U THEN ASSIGN pFieldValue = RowObject.log-reportada.
        &IF '{&mgscm_version}' >= '2.06B' &THEN
            &IF '{&mgscm_version}' >= '2.08' &THEN
               WHEN "log-confer":U THEN ASSIGN pFieldValue = RowObject.log-confer.
            &ELSE 
               WHEN "log-confer":U THEN ASSIGN pFieldValue = RowObject.log-1.
            &ENDIF
        &ENDIF 
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLote DBOProgram 
PROCEDURE getLote :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-wm-etiqueta1
  Parameters:  
               retorna valor do campo id-etiqueta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pcod-item          LIKE wm-etiqueta.cod-item         NO-UNDO.
    DEFINE INPUT PARAMETER  pcod-lote          LIKE wm-etiqueta.cod-lote         NO-UNDO.
    DEFINE INPUT PARAMETER  pcod-refer         LIKE wm-etiqueta.cod-refer        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dt-validade-lote LIKE wm-etiqueta.dt-validade-lote NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/

    FIND FIRST wm-etiqueta
         WHERE wm-etiqueta.cod-item  = pcod-item
           AND wm-etiqueta.cod-lote  = pcod-lote 
           AND wm-etiqueta.cod-refer = pcod-refer NO-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta THEN
        ASSIGN p-dt-validade-lote = wm-etiqueta.dt-validade-lote.
    ELSE 
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOrdProdQtd DBOProgram 
PROCEDURE getOrdProdQtd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-nr-prod     LIKE wm-etiqueta.nr-ord-prod      NO-UNDO.
DEF INPUT  PARAM p-cod-estabel LIKE wm-etiqueta.cod-estabel-ord  NO-UNDO.
DEF OUTPUT PARAM p-qtd-peso    AS DEC NO-UNDO.
DEF OUTPUT PARAM p-qtd-total   AS DEC NO-UNDO.

ASSIGN p-qtd-peso  = 0
       p-qtd-total = 0.

FOR EACH bfwm-etiqueta WHERE 
    bfwm-etiqueta.nr-ord-prod       = p-nr-prod     AND
    bfwm-etiqueta.cod-estabel-ord   = p-cod-estabel AND
    bfwm-etiqueta.ind-sit-agrupador <> 2            AND
    bfwm-etiqueta.ind-leitura       = 2 NO-LOCK:
    
    ASSIGN p-qtd-peso  = p-qtd-peso  + bfwm-etiqueta.qtd-peso 
           p-qtd-total = p-qtd-total + bfwm-etiqueta.qtd-item.
    
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdAgrupadorCarga DBOProgram 
PROCEDURE getQtdAgrupadorCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estabel LIKE wm-docto.cod-estabel  NO-UNDO.
    DEF INPUT  PARAM p-cod-local   LIKE wm-docto.cod-local    NO-UNDO.
    DEF INPUT  PARAM pIdDocto      LIKE wm-docto.id-docto     NO-UNDO.
    DEF OUTPUT PARAM pQtdAgrupador AS INTEGER                 NO-UNDO.
    
    DEF VAR pIdCarga LIKE wm-carga.id-carga NO-UNDO.
    
    ASSIGN pQtdAgrupador = 0.
    
    RUN getCarga IN THIS-PROCEDURE (input   p-cod-estabel,
                                    input   p-cod-local,
                                    INPUT   pIdDocto,
                                    OUTPUT  pIdCarga).   
    
    IF pIdCarga = 0 THEN RETURN "OK":U.
    
    FOR EACH wm-etiqueta WHERE 
        wm-etiqueta.id-carga          = pIdCarga  AND
        wm-etiqueta.ind-sit-agrupador <> 1 NO-LOCK:   /* Somente Agrupadores */
        
        ASSIGN pQtdAgrupador = pQtdAgrupador + 1.
                
    END.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSerialAdrress DBOProgram 
PROCEDURE getSerialAdrress :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pIdEtiqueta   LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
    DEFINE OUTPUT PARAMETER pIdBox        LIKE wm-box.id-box            NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodBloco     LIKE wm-box.cod-bloco         NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodRua       LIKE wm-box.cod-rua           NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodNivel     LIKE wm-box.cod-nivel         NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodColuna    LIKE wm-box.cod-coluna        NO-UNDO.

    ASSIGN pIdBox        = 0
           pCodBloco     = ""
           pCodRua       = ""
           pCodNivel     = ""
           pCodColuna    = "".

    FIND FIRST bf{&TableName}
         WHERE bf{&tablename}.id-etiqueta = pIdEtiqueta NO-LOCK NO-ERROR.

    IF AVAIL bf{&TableName} THEN DO:
        FIND FIRST wm-box-saldo-etiqueta
             WHERE wm-box-saldo-etiqueta.id-etiqueta = bf{&tablename}.id-etiqueta NO-LOCK NO-ERROR.

        IF AVAIL wm-box-saldo-etiqueta THEN DO:

            ASSIGN pIdBox = wm-box-saldo-etiqueta.id-box.

            FIND FIRST wm-box
                 WHERE wm-box.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
                       wm-box.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
                       wm-box.id-box      = wm-box-saldo-etiqueta.id-box      NO-LOCK NO-ERROR.

            IF AVAIL wm-box THEN
                ASSIGN pCodBloco  = wm-box.cod-bloco
                       pCodRua    = wm-box.cod-rua
                       pCodNivel  = wm-box.cod-nivel
                       pCodColuna = wm-box.cod-coluna.
        END.
    END.
    ELSE 
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSerialNaoAgrupadorCarga DBOProgram 
PROCEDURE getSerialNaoAgrupadorCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pIdCarga LIKE wm-carga.id-carga NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttWm-NaoAgrupador.

    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE ttWm-NaoAgrupador.
    &ELSE
        FOR EACH ttWm-NaoAgrupador:
            DELETE ttWm-NaoAgrupador.
        END.
    &ENDIF
    
    FOR EACH  bf{&TableName}
        WHERE bf{&tablename}.id-carga          = pIdCarga                AND
              bf{&tablename}.ind-sit-agrupador = 1 /** Nao Agrupador **/ NO-LOCK:

        /**************************************************************
        ** Verifica se a Etiqueta Agrupadora (Pallet) associada a E- **
        ** tiqueta Nao Agrupa (Item) esta na mesma carga             **
        **************************************************************/
        IF bf{&tablename}.id-agrupador <> 0 THEN DO:
            IF CAN-FIND (FIRST b-wm-etiqueta
                         WHERE b-wm-etiqueta.id-etiqueta = bf{&tablename}.id-agrupador AND
                               b-wm-etiqueta.id-carga    = bf{&tablename}.id-carga     NO-LOCK) THEN
                NEXT.
        END.   

        CREATE ttWm-NaoAgrupador.
        BUFFER-COPY bf{&TableName} TO ttWm-NaoAgrupador.
        ASSIGN ttWm-NaoAgrupador.r-rowid = ROWID(bf{&TableName}).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSituacaoEtiqueta DBOProgram 
PROCEDURE getSituacaoEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pIdEtiqueta LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-etiq-consulta.

    EMPTY TEMP-TABLE tt-etiq-consulta.
    
    /* valida se a etiqueta existe */
    IF NOT CAN-FIND(FIRST wm-etiqueta NO-LOCK
                WHERE wm-etiqueta.id-etiqueta = pIdEtiqueta) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-14 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-14 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-etiqueta-14"}
        RETURN "NOK":U.
    END.
    FOR EACH wms-docto-item-etiq
       WHERE wms-docto-item-etiq.id-etiqueta = pIdEtiqueta NO-LOCK:
        FOR EACH wm-docto
           WHERE wm-docto.cod-estabel    = wms-docto-item-etiq.cod-estabel
             AND wm-docto.cod-local      = wms-docto-item-etiq.cod-local
             AND wm-docto.id-docto       = wms-docto-item-etiq.id-docto
             AND wm-docto.ind-tipo-trans = 2 NO-LOCK:

            CREATE tt-etiq-consulta.
            ASSIGN tt-etiq-consulta.cod-estabel        = wm-docto.cod-estabel
                   tt-etiq-consulta.cod-local          = wm-docto.cod-local
                   tt-etiq-consulta.num-docto          = wm-docto.num-docto
                   tt-etiq-consulta.c-ind-origem-docto = {scinc/i03sc038.i 04 Wm-docto.ind-origem-docto}.
       end.              
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableBloqueioSerial DBOProgram 
PROCEDURE getTableBloqueioSerial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pIdEtiquetaIni LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    DEFINE INPUT  PARAMETER pIdEtiquetaFim LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    DEFINE INPUT  PARAMETER pCodSerialIni  LIKE wm-etiqueta.cod-serial  NO-UNDO.
    DEFINE INPUT  PARAMETER pCodSerialFim  LIKE wm-etiqueta.cod-serial  NO-UNDO.
    DEFINE INPUT  PARAMETER pCodItemIni    LIKE wm-etiqueta.cod-item    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodItemFim    LIKE wm-etiqueta.cod-item    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodReferIni   LIKE wm-etiqueta.cod-refer   NO-UNDO.
    DEFINE INPUT  PARAMETER pCodReferFim   LIKE wm-etiqueta.cod-refer   NO-UNDO.
    DEFINE INPUT  PARAMETER pCodLoteIni    LIKE wm-etiqueta.cod-lote    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodLoteFim    LIKE wm-etiqueta.cod-lote    NO-UNDO.
    DEFINE INPUT  PARAMETER pDataIni       AS   DATE                    NO-UNDO.
    DEFINE INPUT  PARAMETER pDataFim       AS   DATE                    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttWm-BloqueioSerial.

    DEFINE VARIABLE l-busca-id-etiqueta AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-busca-cod-serial  AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-busca-item-refer  AS LOGICAL INITIAL NO NO-UNDO.
    
    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE ttWm-BloqueioSerial.
    &ELSE
        FOR EACH ttWm-BloqueioSerial:
            DELETE ttWm-BloqueioSerial.
        END.
    &ENDIF
    
    /***********************************************************
    * Se forem informados valores para a faixa 'Etiqueta' rea- *
    * liza a busca utilizando o indice idx-wm-etiqueta1.       *
    * Campos do Indice: + id-etiqueta                          *
    ***********************************************************/
    IF  pIdEtiquetaIni <> ?               AND
        pIdEtiquetaFim <> ?               AND
        pIdEtiquetaIni >= 0               AND
        pIdEtiquetaFim  > 0               AND
        pIdEtiquetaFim >= pIdEtiquetaIni  AND
       (pIdEtiquetaIni <> 0               OR
        pIdEtiquetaFim <> 99999999999999) THEN DO:

        ASSIGN l-busca-id-etiqueta = YES.

        FOR EACH  bf{&TableName}
            WHERE bf{&tablename}.id-etiqueta >= pIdEtiquetaIni AND
                  bf{&tablename}.id-etiqueta <= pIdEtiquetaFim NO-LOCK:
            CREATE ttWm-BloqueioSerial.
            BUFFER-COPY bf{&TableName} TO ttWm-BloqueioSerial.
            ASSIGN ttWm-BloqueioSerial.r-rowid = ROWID(bf{&TableName}).
        END.
    END.

    /***********************************************************
    * Se NAO forem informados valores para a faixa 'Etiqueta'  *
    * e informados para a faixa 'Serial' realiza a busca uti-  *
    * lizando o indice wmsetiq-13.                             *
    * Campos do Indice: + cod-serial                           *
    ***********************************************************/
    IF  NOT l-busca-id-etiqueta                           AND
        pCodSerialIni <> "?":U                            AND
        pCodSerialFim <> "?":U                            AND
       (pCodSerialIni <> "":U                             OR
        SUBSTRING(pCodSerialFim,01,10) <> "ZZZZZZZZZZ":U) THEN DO:

        ASSIGN l-busca-cod-serial = YES.

        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-serial >= pCodSerialIni AND
                  bf{&TableName}.cod-serial <= pCodSerialFim NO-LOCK:
            CREATE ttWm-BloqueioSerial.
            BUFFER-COPY bf{&TableName} TO ttWm-BloqueioSerial.
            ASSIGN ttWm-BloqueioSerial.r-rowid = ROWID(bf{&TableName}).
        END.
    END.

    /***********************************************************
    * Se NAO forem informados valores para as faixas 'Etiqueta *
    * e Serial' e informados para a faixa 'Item', 'Referencia' *
    * OU 'Lote' busca utilizando o indice idx-wm-etiqueta2.    *
    * Campos do Indice: + cod-item                             *
    *                   + cod-refer                            *
    *                   + cod-lote                             *
    *                   + dt-validade-lote                     *
    ***********************************************************/
    IF  NOT l-busca-id-etiqueta              AND
        NOT l-busca-cod-serial               AND
       (pCodItemIni  <> "":U                 OR
        pCodItemFim  <> "ZZZZZZZZZZZZZZZZ":U OR
        pCodReferIni <> "":U                 OR
        pCodReferFim <> "ZZZZZZZZ":U         OR
        pCodLoteIni  <> "":U                 OR
        pCodLoteFim  <> "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":U)      THEN DO:

        ASSIGN l-busca-item-refer = YES.

        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-item  >= pCodItemIni  AND
                  bf{&TableName}.cod-item  <= pCodItemFim  AND
                  bf{&TableName}.cod-refer >= pCodReferIni AND
                  bf{&TableName}.cod-refer <= pCodReferFim AND
                  bf{&TableName}.cod-lote  >= pCodLoteIni  AND
                  bf{&TableName}.cod-lote  <= pCodLoteFim  NO-LOCK:
            CREATE ttWm-BloqueioSerial.
            BUFFER-COPY bf{&TableName} TO ttWm-BloqueioSerial.
            ASSIGN ttWm-BloqueioSerial.r-rowid = ROWID(bf{&TableName}).
        END.
    END.

    /***********************************************************
    * Se nao forem informados valores nas faixas, busca utili- *
    * zando o indice idx-wm-etiqueta1.                         *
    * Campos do Indice: + id-etiqueta                          *
    ***********************************************************/
    IF  NOT l-busca-id-etiqueta AND
        NOT l-busca-cod-serial  AND
        NOT l-busca-item-refer  THEN DO:

        FOR EACH  bf{&TableName}
            WHERE bf{&tablename}.id-etiqueta >= pIdEtiquetaIni AND
                  bf{&tablename}.id-etiqueta <= pIdEtiquetaFim AND
                  bf{&TableName}.cod-serial  >= pCodSerialIni  AND
                  bf{&TableName}.cod-serial  <= pCodSerialFim  AND
                  bf{&TableName}.cod-item    >= pCodItemIni    AND
                  bf{&TableName}.cod-item    <= pCodItemFim    AND
                  bf{&TableName}.cod-refer   >= pCodReferIni   AND
                  bf{&TableName}.cod-refer   <= pCodReferFim   AND
                  bf{&TableName}.cod-lote    >= pCodLoteIni    AND
                  bf{&TableName}.cod-lote    <= pCodLoteFim    AND
                  bf{&TableName}.dt-geracao  >= pDataIni       AND
                  bf{&TableName}.dt-geracao  <= pDataFim       NO-LOCK:
            CREATE ttWm-BloqueioSerial.
            BUFFER-COPY bf{&TableName} TO ttWm-BloqueioSerial.
            ASSIGN ttWm-BloqueioSerial.r-rowid = ROWID(bf{&TableName}).
        END.
    END.

    /***********************************************************
    * Processamento local para filtrar os registros que aten-  *
    * dem as faixas de selecao, somente quando a busca for por *
    * Id Etiqueta; ou Codigo Serial; ou Item/Referencia/Lote.  *
    ***********************************************************/
    IF  l-busca-id-etiqueta OR
        l-busca-cod-serial  OR
        l-busca-item-refer  THEN DO:

        FOR EACH ttWm-BloqueioSerial:
            IF  ttWm-BloqueioSerial.id-etiqueta < pIdEtiquetaIni OR
                ttWm-BloqueioSerial.id-etiqueta > pIdEtiquetaFim OR
                ttWm-BloqueioSerial.cod-serial  < pCodSerialIni  OR
                ttWm-BloqueioSerial.cod-serial  > pCodSerialFim  OR
                ttWm-BloqueioSerial.cod-item    < pCodItemIni    OR
                ttWm-BloqueioSerial.cod-item    > pCodItemFim    OR
                ttWm-BloqueioSerial.cod-refer   < pCodReferIni   OR
                ttWm-BloqueioSerial.cod-refer   > pCodReferFim   OR
                ttWm-BloqueioSerial.cod-lote    < pCodLoteIni    OR
                ttWm-BloqueioSerial.cod-lote    > pCodLoteFim    OR
                ttWm-BloqueioSerial.dt-geracao  < pDataIni       OR
                ttWm-BloqueioSerial.dt-geracao  > pDataFim       THEN
                DELETE ttWm-BloqueioSerial.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableEmbalagem DBOProgram 
PROCEDURE getTableEmbalagem :
/*------------------------------------------------------------------------------
  Purpose...: Metodo Auxiliar chamado pela procedure 'returnImpressaoEtiqueta'
  Parameters: ENTRADA - p-cod-estabel - Codigo do Estabelecimento
                        p-cod-local   - Codigo do Local
                        p-cod-item    - Codigo do Item
                        p-qtd-item    - Quantidade do Item
              SAIDA   - Temp-table tt-embalagem
  Notes.....: Engenharia Geracao Etiquetas Recebimento
------------------------------------------------------------------------------*/

    /* Definicao Parametros */
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE wm-docto-itens.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-local   LIKE wm-docto-itens.cod-local   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-item    LIKE wm-docto-itens.cod-item    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embalagem.

    /* Limpeza Temp-Table's */
    RUN emptyRowErrors IN THIS-PROCEDURE.

    /* Logica Principal */
    &IF "{&bf_mat_versao_ems}":U < "2.062":U &THEN
        FIND FIRST wm-item-etiq
             WHERE wm-item-etiq.cod-item = p-cod-item NO-LOCK NO-ERROR.

        IF  NOT AVAIL wm-item-etiq THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-etiqueta AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Etiqueta" *}
            ASSIGN c-lbl-liter-item-etiqueta = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-item-etiqueta + ' ' + STRING(p-cod-item)"}
            RETURN "NOK":U.
        END.
    &ELSE
        FIND FIRST wm-item
             WHERE wm-item.cod-item = p-cod-item NO-LOCK NO-ERROR.

        IF  NOT AVAIL wm-item THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-item + ' ' + STRING(p-cod-item)"}
            RETURN "NOK":U.
        END.
    &ENDIF
    
    FOR EACH  wm-item-embalagem-local
        WHERE wm-item-embalagem-local.cod-estabel = p-cod-estabel AND
              wm-item-embalagem-local.cod-local   = p-cod-local   AND
              wm-item-embalagem-local.cod-item    = p-cod-item    NO-LOCK:

        FIND FIRST wm-item-embalagem-etiq
             WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item      AND
                   wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-embalagem NO-LOCK NO-ERROR.

        /* Criacao Temp-table tt-embalagem */
        {scbo/bosc074.i2 wm-item-embalagem-local.qtd-item-emb YES}

        FIND FIRST wm-item-embalagem-etiq
             WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item     AND
                   wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-emb-item NO-LOCK NO-ERROR.

        /* Criacao Temp-table tt-embalagem */
        {scbo/bosc074.i2 wm-item-embalagem-local.qtd-emb-item NO}
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableImpressao DBOProgram 
PROCEDURE getTableImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao Parametros */
    DEFINE INPUT PARAMETER p-etiqueta-ini   LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
    DEFINE INPUT PARAMETER p-etiqueta-fim   LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
    DEFINE INPUT PARAMETER p-agrupador-ini  LIKE wm-etiqueta.id-agrupador NO-UNDO.
    DEFINE INPUT PARAMETER p-agrupador-fim  LIKE wm-etiqueta.id-agrupador NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-ini      LIKE wm-etiqueta.id-carga     NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-fim      LIKE wm-etiqueta.id-carga     NO-UNDO.
    DEFINE INPUT PARAMETER p-nao-agrupa     AS   LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER p-agrup-etiqueta AS   LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER p-agrup-proprio  AS   LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao       AS   INTEGER                  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-impressao-etiq.

    /* Definicao Variaveis Locais */
    DEFINE VARIABLE l-busca-id-etiqueta  AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-busca-id-agrupador AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-busca-id-carga     AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-busca-global       AS LOGICAL INITIAL NO NO-UNDO.

    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-impressao-etiq.
    &ELSE
        FOR EACH tt-impressao-etiq:
            DELETE tt-impressao-etiq.
        END.
    &ENDIF
    
    /***********************************************************
    * Se forem informados valores para a faixa 'Etiqueta' rea- *
    * liza a busca utilizando o indice idx-wm-etiqueta1.       *
    * Campos do Indice: + id-etiqueta                          *
    ***********************************************************/
    IF  p-etiqueta-ini <> ?               AND
        p-etiqueta-fim <> ?               AND
        p-etiqueta-ini >= 0               AND
        p-etiqueta-fim  > 0               AND
        p-etiqueta-fim >= p-etiqueta-ini  AND
       (p-etiqueta-ini <> 0               OR
        p-etiqueta-fim <> 99999999999999) THEN DO:

        ASSIGN l-busca-id-etiqueta = YES.

        FOR EACH  b-wm-etiqueta
            WHERE b-wm-etiqueta.id-etiqueta >= p-etiqueta-ini AND
                  b-wm-etiqueta.id-etiqueta <= p-etiqueta-fim NO-LOCK:
            IF  NOT CAN-FIND (FIRST tt-impressao-etiq
                              WHERE tt-impressao-etiq.id-etiqueta = b-wm-etiqueta.id-etiqueta NO-LOCK) THEN DO:
                CREATE tt-impressao-etiq.
                BUFFER-COPY b-wm-etiqueta TO tt-impressao-etiq.
                ASSIGN tt-impressao-etiq.r-rowid = ROWID(b-wm-etiqueta).
            END.
        END.
    END.

    /***********************************************************
    * Se forem informados valores para a faixa 'Id Agrupador'  *
    * realiza a busca utilizando o indice idx-wm-etiqueta9.    *
    * Campos do Indice: + id-agrupador                         *
    *                   + id-etiqueta                          *
    ***********************************************************/
    IF  p-agrupador-ini <> ?               AND
        p-agrupador-fim <> ?               AND
        p-agrupador-ini >= 0               AND
        p-agrupador-fim  > 0               AND
        p-agrupador-fim >= p-agrupador-ini AND
       (p-agrupador-ini <> 0               OR
        p-agrupador-fim <> 99999999999999) THEN DO:

        ASSIGN l-busca-id-agrupador = YES.

        FOR EACH  b-wm-etiqueta
            WHERE b-wm-etiqueta.id-agrupador >= p-agrupador-ini AND
                  b-wm-etiqueta.id-agrupador <= p-agrupador-fim NO-LOCK:
            IF  NOT CAN-FIND (FIRST tt-impressao-etiq
                              WHERE tt-impressao-etiq.id-etiqueta = b-wm-etiqueta.id-etiqueta NO-LOCK) THEN DO:
                CREATE tt-impressao-etiq.
                BUFFER-COPY b-wm-etiqueta TO tt-impressao-etiq.
                ASSIGN tt-impressao-etiq.r-rowid = ROWID(b-wm-etiqueta).
            END.
        END.
    END.

    /***********************************************************
    * Se forem informados valores para a faixa 'Id Carga' rea- *
    * liza a busca utilizando o indice idx-wm-etiqueta4.       *
    * Campos do Indice: + id-carga                             *
    ***********************************************************/
    IF  p-carga-ini <> ?               AND
        p-carga-fim <> ?               AND
        p-carga-ini >= 0               AND
        p-carga-fim  > 0               AND
        p-carga-fim >= p-carga-ini     AND
       (p-carga-ini <> 0               OR
        p-carga-fim <> 99999999999999) THEN DO:

        ASSIGN l-busca-id-carga = YES.

        FOR EACH  b-wm-etiqueta
            WHERE b-wm-etiqueta.id-carga >= p-carga-ini AND
                  b-wm-etiqueta.id-carga <= p-carga-fim NO-LOCK:
            IF  NOT CAN-FIND (FIRST tt-impressao-etiq
                              WHERE tt-impressao-etiq.id-etiqueta = b-wm-etiqueta.id-etiqueta NO-LOCK) THEN DO:
                CREATE tt-impressao-etiq.
                BUFFER-COPY b-wm-etiqueta TO tt-impressao-etiq.
                ASSIGN tt-impressao-etiq.r-rowid = ROWID(b-wm-etiqueta).
            END.
        END.
    END.

    /***********************************************************
    * Se nenhuma faixa for informada, carrega tabela inteira!  *
    ***********************************************************/
    IF  NOT l-busca-id-etiqueta          AND
        NOT l-busca-id-agrupador         AND
        NOT l-busca-id-carga             AND
        p-etiqueta-ini  = 0              AND
        p-etiqueta-fim  = 99999999999999 AND
        p-agrupador-ini = 0              AND
        p-agrupador-fim = 99999999999999 AND
        p-carga-ini     = 0              AND
        p-carga-fim     = 99999999999999 THEN DO:

        ASSIGN l-busca-global = YES.

        FOR EACH b-wm-etiqueta NO-LOCK:
            IF  NOT CAN-FIND (FIRST tt-impressao-etiq
                              WHERE tt-impressao-etiq.id-etiqueta = b-wm-etiqueta.id-etiqueta NO-LOCK) THEN DO:
                CREATE tt-impressao-etiq.
                BUFFER-COPY b-wm-etiqueta TO tt-impressao-etiq.
                ASSIGN tt-impressao-etiq.r-rowid = ROWID(b-wm-etiqueta).
            END.
        END.
    END.

    /***********************************************************
    * Processamento local para filtrar os registros que aten-  *
    * dem as Faixas de Selecao.                                *
    ***********************************************************/
    IF  l-busca-id-etiqueta  OR
        l-busca-id-agrupador OR
        l-busca-id-carga     OR
        l-busca-global       THEN DO:

        FOR EACH tt-impressao-etiq:

            IF  NOT (tt-impressao-etiq.id-etiqueta  >= p-etiqueta-ini  AND
                     tt-impressao-etiq.id-etiqueta  <= p-etiqueta-fim  AND
                     tt-impressao-etiq.id-agrupador >= p-agrupador-ini AND
                     tt-impressao-etiq.id-agrupador <= p-agrupador-fim AND
                     tt-impressao-etiq.id-carga     >= p-carga-ini     AND
                     tt-impressao-etiq.id-carga     <= p-carga-fim)    THEN DO:
                DELETE tt-impressao-etiq.
                NEXT.
            END.

            IF  NOT p-nao-agrupa                        AND
                tt-impressao-etiq.ind-sit-agrupador = 1 THEN DO:
                DELETE tt-impressao-etiq.
                NEXT.
            END.

            IF  NOT p-agrup-etiqueta                    AND
                tt-impressao-etiq.ind-sit-agrupador = 2 THEN DO:
                DELETE tt-impressao-etiq.
                NEXT.
            END.

            IF  NOT p-agrup-proprio                     AND
                tt-impressao-etiq.ind-sit-agrupador = 3 THEN DO:
                DELETE tt-impressao-etiq.
                NEXT.
            END.

            CASE p-situacao:
                /* Impressas */
                WHEN 1 THEN DO:
                    IF  NOT tt-impressao-etiq.log-impressa THEN DO:
                        DELETE tt-impressao-etiq.
                        NEXT.
                    END.
                END.

                /* Nao Impressas */
                WHEN 2 THEN DO:
                    IF  tt-impressao-etiq.log-impressa THEN DO:
                        DELETE tt-impressao-etiq.
                        NEXT.
                    END.
                END.
            END CASE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUsuario DBOProgram 
PROCEDURE getUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pUserName AS CHAR NO-UNDO.

    DEFINE VARIABLE hSOAutentic AS HANDLE NO-UNDO.
        
    {method/svc/autentic/autentic.i &vUserName="pUserName"}

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice idx-wm-etiqueta1
  Parameters:  
               recebe valor do campo id-etiqueta
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pid-etiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    FIND FIRST bfwm-etiqueta 
         WHERE bfwm-etiqueta.id-etiqueta = pid-etiqueta NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfwm-etiqueta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfwm-etiqueta)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
               recebe valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pCodSerial LIKE wm-etiqueta.cod-serial NO-UNDO.

    FIND FIRST bfwm-etiqueta 
         WHERE bfwm-etiqueta.cod-serial = pCodSerial NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfwm-etiqueta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfwm-etiqueta)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey3 DBOProgram 
PROCEDURE goToKey3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
               recebe valor do campo id-etiqueta
               recebe valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pIdEtiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    DEFINE INPUT PARAMETER pCodSerial  LIKE wm-etiqueta.cod-serial  NO-UNDO.

    FIND FIRST bfwm-etiqueta 
         WHERE bfwm-etiqueta.id-etiqueta = pIdEtiqueta AND
               bfwm-etiqueta.cod-serial  = pCodSerial  NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfwm-etiqueta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfwm-etiqueta)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inutilizaEtiquetas DBOProgram 
PROCEDURE inutilizaEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    
  Quando for uma etiqueta de item, seja ele £nico por pallet ou que sofra
  agrupamento, seu status ser† trocado para "inutilizado".
  
  Quando for uma etiqueta de agrupador, esta ser† inutilizada e os seriais 
  que ela agrupava ser∆o retornados, com o status de lido e o id-agrupador
  igual a zero. 
  
  
  O mÇtodo consiste em informar um serial para ser inutilizado pelo sistema. 
  No caso de etiqueta que sofre agrupamento, somente Ç permitida sua inutilizaá∆o 
  caso n∆o esteja vinculada a um agrupador.
  No caso de etiqueta agrupadora, somente ser† permitida sua inutilizaá∆o caso 
  ela n∆o esteja vinculada a uma carga. Se n∆o estiver, todas as etiquetas que 
  estavam agrupadas a ela ter∆o o atributo "id-agrupador = 0" e seus seriais 
  alimentados na temp-table passada por parÉmetro.
  Finalmente, se for uma etiqueta de agrupador £nico,  somente ser† inutilizada 
  se n∆o estiver vinculada a nenhuma carga.
  
  
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pSerial  AS DECIMAL. /* Serial a ser inutilizado */
    DEF OUTPUT PARAM TABLE FOR ttSerial.  /* Temp-table com os seriais dos itens pertencentes
                                             ao agrupador que ser† inutilizado */

    DEF VAR c-serial AS CHAR NO-UNDO.

    FOR EACH ttSerial:
        DELETE ttSerial.
    END.

        
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerial 
        EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-15 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-15 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-15"}
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.ind-leitura-etiqueta = 3 THEN DO:  /* Inutilizado */
        {method/svc/errors/inserr.i
            &ErrorNumber="26477"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK":U.
    END.
    
    CASE wm-etiqueta.ind-sit-agrupador:
        /*********************************************************************/   
        WHEN 1 THEN DO: /* N∆o agrupa - ITEM         */
            
            IF wm-etiqueta.id-agrupador <> 0 THEN DO:  /* Pertence a um agrupador*/
            
                FIND FIRST bf{&TableName} 
                    WHERE bf{&tablename}.id-etiqueta = wm-etiqueta.id-agrupador 
                    NO-LOCK NO-ERROR.
                
                IF AVAIL bf{&TableName} THEN DO:
                
                    ASSIGN c-serial = STRING(pSerial).


                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-agrupador-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Agrupador" *}
                    ASSIGN c-lbl-liter-agrupador-2 = TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i
                        &ErrorNumber="26061"
                        &ErrorType="EMS"
                        &ErrorParameters="c-serial + '~~~~' + c-lbl-liter-agrupador-2"}
                    
                    RELEASE wm-etiqueta.
                    RETURN "NOK":U.
                    
                END.
                    
            END.
            
            ASSIGN wm-etiqueta.id-agrupador         = 0
                   wm-etiqueta.ind-leitura-etiqueta = 3.  /* Inutilizado */
            
        END.     
                
        /*********************************************************************/        
        WHEN 2 THEN DO: /* Agrupador Etiquetas  - PALLET */

            /*Se n∆o est† reportada */
            ASSIGN c-serial = STRING(pSerial).
            IF wm-etiqueta.log-reportada = YES THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="26324"
                    &ErrorType="EMS"
                    &ErrorParameters="c-serial"}
                RELEASE wm-etiqueta.
                RETURN "NOK":U.
            END.


            IF wm-etiqueta.id-carga <> 0 THEN DO:
                
                FIND FIRST wm-carga 
                    WHERE wm-carga.id-carga = wm-etiqueta.id-carga
                    NO-LOCK NO-ERROR. 
                    
                IF AVAIL wm-carga THEN DO:                     
                    ASSIGN c-serial = STRING(pSerial).

                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-carga-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Carga" *}
                    ASSIGN c-lbl-liter-carga-3 = TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i
                        &ErrorNumber="26061"
                        &ErrorType="EMS"
                        &ErrorParameters="c-serial + '~~~~' + c-lbl-liter-carga-3"}
                    RELEASE wm-etiqueta.
                    RETURN "NOK":U.
                END.
                
            END.
            
            ASSIGN wm-etiqueta.id-carga             = 0
                   wm-etiqueta.ind-leitura-etiqueta = 3.  /* Inutilizado */
                   
            /* Alimentar a TT com os seriais que pertenciam ao agrupador */
            FOR EACH bf{&TableName} 
                WHERE bf{&tablename}.id-agrupador = pSerial EXCLUSIVE-LOCK.
                
                CREATE ttSerial.
                ASSIGN ttSerial.de-serial          = bf{&tablename}.id-etiqueta
                       bf{&tablename}.id-agrupador = 0.
            
            END.
            
            RELEASE bf{&TableName}.
            
        END.            
        
        /*********************************************************************/
        WHEN 3 THEN DO: /* Agrupador Pr¢prio   */
        
        
            /*Se n∆o est† reportada */
            ASSIGN c-serial = STRING(pSerial).
            IF wm-etiqueta.log-reportada = YES THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="26324"
                    &ErrorType="EMS"
                    &ErrorParameters="c-serial"}
                RELEASE wm-etiqueta.
                RETURN "NOK":U.
            END.

            IF wm-etiqueta.id-carga <> 0 THEN DO:
            
                FIND FIRST wm-carga 
                    WHERE wm-carga.id-carga = wm-etiqueta.id-carga
                    NO-LOCK NO-ERROR. 
                    
                IF AVAIL wm-carga THEN DO:                     
                    ASSIGN c-serial = STRING(pSerial).

                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-carga-4 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Carga" *}
                    ASSIGN c-lbl-liter-carga-4 = TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i
                        &ErrorNumber="26061"
                        &ErrorType="EMS"
                        &ErrorParameters="c-serial + '~~~~' + c-lbl-liter-carga-4"}
                    RELEASE wm-etiqueta.
                    RETURN "NOK":U.
                END.
                
            END.
            
            ASSIGN wm-etiqueta.id-carga             = 0
                   wm-etiqueta.ind-leitura-etiqueta = 3.  /* Inutilizado */
        
            
        END.
        
        OTHERWISE RETURN "NOK":U.

    END CASE.        
        
    RELEASE wm-etiqueta.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leEtiquetas DBOProgram 
PROCEDURE leEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  Este mÇtodo consiste na troca de status de leitura da etiqueta e na atualizaá∆o 
  da data de leitura. Consiste se a etiqueta Ç uma etiqueta de item, se j† n∆o 
  pertence a um agrupador, se j† n∆o est† lida.


------------------------------------------------------------------------------*/
    DEF INPUT PARAM pSerialitem  AS DECIMAL.     /* Serial do Item           */
    DEF INPUT PARAM pCodUsuario  LIKE wm-etiqueta.cod-usuario NO-UNDO.     /* Usu†rio */
    
    
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerialitem EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-16 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-16 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-16"}
        RETURN "NOK".
    END.       
    
    /* Etiqueta j† associada a um agrupador */
    IF wm-etiqueta.id-agrupador <> 0 THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26006"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.
    
    /* Etiqueta n∆o Ç de item que sofre associaá∆o */
    IF wm-etiqueta.ind-sit-agrupador <> 1 THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26005"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.
    
    /*cadastrar mensagem de etiqueta j† lida */
    IF wm-etiqueta.ind-leitura-etiqueta = 2 THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26004"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.    

    /*cadastrar mensagem de etiqueta j† lida */
    IF wm-etiqueta.ind-leitura-etiqueta = 3 THEN DO:  /* Inutilizada */
        {method/svc/errors/inserr.i
            &ErrorNumber="26382"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.    


    ASSIGN wm-etiqueta.ind-leitura-etiqueta = 2   /* LIDA */
           wm-etiqueta.dt-leitura           = TODAY
           wm-etiqueta.cod-usuario          = pCodUsuario.
            
    RELEASE wm-etiqueta.
           
    RETURN "OK".
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leEtiquetasAgrupadorProprio DBOProgram 
PROCEDURE leEtiquetasAgrupadorProprio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  Este mÇtodo consiste na troca de status de leitura da etiqueta e na atualizaá∆o 
  da data de leitura. Consiste se a etiqueta Ç uma etiqueta de item, se j† n∆o 
  pertence a um agrupador, se j† n∆o est† lida.

------------------------------------------------------------------------------*/
    DEF INPUT PARAM pSerialitem  AS DECIMAL.     /* Serial do Item           */
    DEF INPUT PARAM pCodUsuario  LIKE wm-etiqueta.cod-usuario NO-UNDO.     /* Usu†rio */
    
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerialitem EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-17 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-17 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-17"}
        RETURN "NOK".
    END.       

    /* Etiqueta n∆o Ç serial de agrupador pr¢prio */
    IF wm-etiqueta.ind-sit-agrupador <> 3 THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-agrupador-proprio AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Agrupador_Pr¢prio" *}
        ASSIGN c-lbl-liter-agrupador-proprio = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-agrupador-proprio"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.    
    
    /*cadastrar mensagem de etiqueta j† lida */
    IF wm-etiqueta.ind-leitura-etiqueta = 2 THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26004"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.    

    /*cadastrar mensagem de etiqueta j† lida */
    IF wm-etiqueta.ind-leitura-etiqueta = 3 THEN DO:  /* Inutilizada */
        {method/svc/errors/inserr.i
            &ErrorNumber="26382"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RELEASE wm-etiqueta.
        RETURN "NOK".
    END.    


    ASSIGN wm-etiqueta.ind-leitura-etiqueta = 2   /* LIDA */
           wm-etiqueta.dt-leitura           = TODAY
           wm-etiqueta.cod-usuario          = pCodUsuario.
    
    RELEASE wm-etiqueta.
           
    RETURN "OK".
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCarga DBOProgram 
PROCEDURE linkToCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM hDBOWm-Carga AS HANDLE NO-UNDO.
DEF VAR p-id-carga    LIKE Wm-carga.id-carga NO-UNDO.
DEF VAR p-cod-cliente LIKE Wm-cliente.cod-cliente NO-UNDO.

RUN getKey IN hDBoWm-Carga (OUTPUT p-id-carga,
                            OUTPUT p-cod-cliente).

RUN setConstraintCarga IN THIS-PROCEDURE (INPUT p-id-carga).
RUN openQueryCarga IN THIS-PROCEDURE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAgrupador DBOProgram 
PROCEDURE openQueryAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX idx-wm-etiqueta9 WHERE
         {&tablename}.id-agrupador      = i-id-etiqueta AND
         {&tablename}.ind-sit-agrupador = 1 NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAgrupadores DBOProgram 
PROCEDURE openQueryAgrupadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&tablename}.ind-sit-agrupador > 1  AND
         {&tablename}.id-carga          = 0  AND
         {&TableName}.log-reportada     = yes NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCarga DBOProgram 
PROCEDURE openQueryCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&tablename}.ind-sit-agrupador > 1           AND
         {&tablename}.id-carga          = i-id-carga  NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCompCarga DBOProgram 
PROCEDURE openQueryCompCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&tablename}.id-carga          = i-id-carga NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEtiquetas DBOProgram 
PROCEDURE openQueryEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         {&tablename}.id-agrupador         = 0  AND
         {&tablename}.ind-sit-agrupador    = 1  AND
         {&tablename}.ind-leitura-etiqueta <> 3 AND  /* Inutilizado */
         {&TableName}.cod-item             = c-cod-item    AND
         {&TableName}.cod-refer            = c-cod-refer   AND
         {&TableName}.cod-lote             = c-cod-lote    AND
         {&TableName}.nr-ord-prod          = i-nr-ord-prod AND
         {&TableName}.cod-estabel          = c-cod-estabel /*AND
         {&TableName}.cod-estabel-ord      = c-cod-estabel-ord*/ NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF l-inf-carga THEN 
        OPEN QUERY {&QueryName} 
        FOR EACH  {&TableName} USE-INDEX idx-wm-etiqueta4 
           WHERE  {&tablename}.id-carga          = de-id-carga  AND
                 ({&tablename}.ind-sit-agrupador = i-nao-agrupa OR
                  {&tablename}.ind-sit-agrupador = i-agrupador  OR
                  {&tablename}.ind-sit-agrupador = i-proprio)   NO-LOCK INDEXED-REPOSITION.
    ELSE
        OPEN QUERY {&QueryName} 
        FOR EACH  {&TableName} USE-INDEX idx-wm-etiqueta1 
           WHERE ({&tablename}.ind-sit-agrupador = i-nao-agrupa OR
                  {&tablename}.ind-sit-agrupador = i-agrupador  OR
                  {&tablename}.ind-sit-agrupador = i-proprio)   NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOP DBOProgram 
PROCEDURE openQueryOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX idx-wm-etiqueta7 WHERE
         {&TableName}.cod-estabel-ord = c-cod-estabel-ord AND
         {&TableName}.nr-ord-prod     = i-nr-ord-prod NO-LOCK.
         
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         ({&tablename}.id-etiqueta >= i-id-etiqueta-ini AND
          {&tablename}.id-etiqueta <= i-id-etiqueta-fim) AND
         ({&tablename}.ind-sit-agrupador = i-nao-agrupa OR
          {&tablename}.ind-sit-agrupador = i-agrupador  OR
          {&tablename}.ind-sit-agrupador = i-proprio) NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom2 DBOProgram 
PROCEDURE openQueryZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
         ({&tablename}.id-carga           = i-id-carga  AND
          {&tablename}.id-carga          <> 0           AND
          {&tablename}.ind-sit-agrupador <> 1           AND
         ({&tablename}.id-etiqueta >= i-id-etiqueta-ini AND
          {&tablename}.id-etiqueta <= i-id-etiqueta-fim))  NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printEtiquetas DBOProgram 
PROCEDURE printEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCod-usuario      AS CHAR NO-UNDO.
DEF INPUT PARAM pId-etiqueta-ini  AS DEC  NO-UNDO.
DEF INPUT PARAM pId-etiqueta-fim  AS DEC  NO-UNDO.

If Connected('mgcld') Then Do:

   RUN scbo/bosc074a.p (INPUT pCod-usuario,
                        INPUT pId-etiqueta-ini,
                        INPUT pId-etiqueta-fim).
                       

End. /* If Connected('mgcld') */
Else
    RETURN "NOK":U.
 
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeCarga DBOProgram 
PROCEDURE removeCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id-etiqueta  LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    
    FIND FIRST bf{&TableName}
         WHERE bf{&tablename}.id-etiqueta = p-id-etiqueta EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL bf{&TableName} THEN DO:
        ASSIGN bf{&tablename}.id-carga = 0.

        /**********************************************************
        ** Para Etiquetas do tipo Agrupador (Pallet), devera ser **
        ** executa a logica abaixo para desassociar as Etiquetas **
        ** Nao Agrupa (Itens) que estao associadas ao Pallet     **
        **********************************************************/
        IF bf{&tablename}.ind-sit-agrupador = 2 THEN DO:
            FOR EACH  b-wm-etiqueta
                WHERE b-wm-etiqueta.id-agrupador = bf{&tablename}.id-etiqueta EXCLUSIVE-LOCK:
                ASSIGN b-wm-etiqueta.id-carga = 0.
            END.
        END.
    END.

    FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.
    
    RELEASE bf{&TableName} NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsEtiqueta DBOProgram 
PROCEDURE returnFieldsEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pIdEtiqueta   AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pSitAgrupad   AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdItem      AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdItemRetir AS DECIMAL NO-UNDO.
    
    FIND FIRST wm-etiqueta
         WHERE wm-etiqueta.id-etiqueta = pIdEtiqueta NO-LOCK NO-ERROR.

    IF AVAIL wm-etiqueta THEN 
        ASSIGN pSitAgrupad   = wm-etiqueta.ind-sit-agrupador
               pQtditem      = wm-etiqueta.qtd-item
               pQtdItemRetir = wm-etiqueta.qtd-item-retir.
    ELSE 
        ASSIGN pSitAgrupad   = 0
               pQtditem      = 0
               pQtdItemRetir = 0.               
    
    RETURN "OK":U.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnImpressaoEtiqueta DBOProgram 
PROCEDURE returnImpressaoEtiqueta :
/*------------------------------------------------------------------------------
  Purpose...: Retornar TT tt-embalagem que sera utilizada pelo Data Collection
  Parameters: ENTRADA - p-cod-estabel - Codigo do Estabelecimento
                        p-cod-local   - Codigo do Local
                        p-id-docto    - Identificador Unico do Documento
                        p-cod-item    - Codigo do Item
              SAIDA   - Temp-table tt-embalagem
                        Temp-table RowErrors
  Notes.....: Engenharia Geracao Etiquetas Recebimento
------------------------------------------------------------------------------*/

    /* Definicao Parametros */
    &IF "{&mguni_version}" >= "2.071" &THEN
        DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER FORMAT "X(05)":U      NO-UNDO.
    &ELSE
        DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER FORMAT "X(03)":U      NO-UNDO.
    &ENDIF
    
    DEFINE INPUT  PARAMETER p-cod-local   AS CHARACTER FORMAT "X(03)":U      NO-UNDO.
    DEFINE INPUT  PARAMETER p-id-docto    AS DECIMAL   FORMAT "9999999999":U NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-item    AS CHARACTER FORMAT "X(16)":U      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embalagem.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE qtd-item-impresso     AS DECIMAL                         NO-UNDO.
    DEFINE VARIABLE c-trad                AS CHAR                            NO-UNDO.
    DEFINE VARIABLE d-qtd-box-aux LIKE wm-box-movto.qtd-item NO-UNDO.
    
    /* Limpeza Temp-Table's */
    RUN emptyRowErrors IN THIS-PROCEDURE.

    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-embalagem.
    &ELSE
        FOR EACH tt-embalagem:
            DELETE tt-embalagem.
        END.
    &ENDIF
    
    /* Logica Principal */
    IF  p-id-docto = 0 THEN DO:
        RUN getTableEmbalagem IN THIS-PROCEDURE (INPUT  p-cod-estabel,
                                                 INPUT  p-cod-local,
                                                 INPUT  p-cod-item,
                                                 OUTPUT TABLE tt-embalagem).

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND (FIRST wm-docto-itens
                          WHERE wm-docto-itens.cod-estabel = p-cod-estabel AND
                                wm-docto-itens.cod-local   = p-cod-local   AND
                                wm-docto-itens.id-docto    = p-id-docto    NO-LOCK) THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento" *}
            ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-documento"}
            RETURN "NOK":U.
        END.
        /* Passa a permitir a liberaá∆o de sequencias mesmo se o documento j† possuir carga associada.
        ELSE IF NOT CAN-FIND(FIRST wm-docto WHERE
                wm-docto.cod-estabel = p-cod-estabel AND
                wm-docto.cod-local   = p-cod-local   AND
                wm-docto.id-docto    = p-id-docto    AND 
                wm-docto.id-carga    = 0             NO-LOCK) THEN  DO:
            {method/svc/errors/inserr.i &ErrorNumber="25997"
                                        &ErrorType="EMS"
                                        &ErrorParameters="'Carga j† relacionada ao Documento~~N∆o Ç poss°vel gerar etiquetas se j† existir carga relacionada ao documento. A impress∆o deve ser realizada pelo programa WM0120.'"}
            RETURN "NOK":U.
        END.
        */
        ELSE DO:
            FIND FIRST wm-docto WHERE
                wm-docto.cod-estabel = p-cod-estabel AND
                wm-docto.cod-local   = p-cod-local   AND
                wm-docto.id-docto    = p-id-docto    NO-LOCK NO-ERROR.

            IF AVAIL wm-docto THEN DO:
                FOR EACH wm-docto-itens
                   WHERE wm-docto-itens.cod-estabel = p-cod-estabel AND
                         wm-docto-itens.cod-local   = p-cod-local   AND
                         wm-docto-itens.id-docto    = p-id-docto    NO-LOCK:

                   ASSIGN l-encontrou   = NO
                          i-qtd-emb     = 0
                          d-qtd-box-aux = 0.

                   IF CAN-FIND (FIRST wm-box-movto NO-LOCK
                                WHERE wm-box-movto.cod-local      = wm-docto-itens.cod-local    
                                  AND wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel  
                                  AND wm-box-movto.id-docto       = wm-docto-itens.id-docto     
                                  AND wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item 
                                  AND wm-box-movto.ind-tipo-movto = 1 ) THEN
                       ASSIGN l-encontrou = YES.
                   IF l-encontrou  THEN DO:
                       FOR EACH wm-box-movto 
                          WHERE wm-box-movto.cod-local      = wm-docto-itens.cod-local    AND 
                                wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel  AND
                                wm-box-movto.id-docto       = wm-docto-itens.id-docto     AND 
                                wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item AND
                                wm-box-movto.ind-tipo-movto = 1 NO-LOCK:

                          ASSIGN d-qtd-box-aux = 1.                     
                          
                          REPEAT:
                              IF d-qtd-box-aux > wm-box-movto.qti-embalagem THEN LEAVE.
                          
                              ASSIGN i-qtd-emb = i-qtd-emb + 1.
                              
                              RUN getTableEmbalagem IN THIS-PROCEDURE (INPUT  wm-docto-itens.cod-estabel,
                                                                       INPUT  wm-docto-itens.cod-local,
                                                                       INPUT  wm-docto-itens.cod-item,
                                                                       OUTPUT TABLE tt-embalagem).
                          
                              ASSIGN d-qtd-box-aux = d-qtd-box-aux + 1.
                          END.
                          FOR EACH tt-embalagem WHERE 
                                   tt-embalagem.codItem  = wm-docto-itens.cod-item AND
                                   tt-embalagem.codRefer = ""                      AND
                                   tt-embalagem.codLote  = ""                      AND 
                                   tt-embalagem.qtdItem  = 0:
                          
                                  ASSIGN tt-embalagem.codItem         = wm-docto-itens.cod-item        
                                         tt-embalagem.codRefer        = wm-docto-itens.cod-refer       
                                         tt-embalagem.codLote         = wm-docto-itens.cod-lote        
                                         tt-embalagem.dtValidadeLote  = wm-docto-itens.dt-validade-lote
                                         tt-embalagem.numSeqItem      = wm-docto-itens.num-seq-item    
                                         tt-embalagem.qtdItem         = IF (wm-docto-itens.qtd-item - wm-box-movto.qtd-item) > 0 THEN
                                                                            wm-box-movto.qtd-item 
                                                                        ELSE 
                                                                            wm-docto-itens.qtd-item
                                         tt-embalagem.id-movto        = wm-box-movto.id-movto.
                           END.    
                       END.
                   END.
                   ELSE DO: 
                       RUN getTableEmbalagem IN THIS-PROCEDURE (INPUT  wm-docto-itens.cod-estabel,
                                                                INPUT  wm-docto-itens.cod-local,
                                                                INPUT  wm-docto-itens.cod-item,
                                                                OUTPUT TABLE tt-embalagem).

                       FOR EACH tt-embalagem WHERE 
                                tt-embalagem.codItem  = wm-docto-itens.cod-item AND
                                tt-embalagem.codRefer = ""                      AND
                                tt-embalagem.codLote  = ""                      AND 
                                tt-embalagem.qtdItem  = 0:
                           
                               ASSIGN tt-embalagem.codItem         = wm-docto-itens.cod-item        
                                      tt-embalagem.codRefer        = wm-docto-itens.cod-refer       
                                      tt-embalagem.codLote         = wm-docto-itens.cod-lote        
                                      tt-embalagem.dtValidadeLote  = wm-docto-itens.dt-validade-lote
                                      tt-embalagem.numSeqItem      = wm-docto-itens.num-seq-item    
                                      tt-embalagem.qtdItem         = wm-docto-itens.qtd-item.
                       END.    
                   END.
                   
                   IF RETURN-VALUE = "NOK":U THEN
                       RETURN "NOK":U.

                END. 
            END.
        END.
    END.
            
    FIND FIRST tt-embalagem NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt-embalagem THEN DO:
        {utp/ut-liter.i "Embalagem para o item" *}
        ASSIGN c-trad = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "o programa de manutená∆o de embalagem" *}
        {method/svc/errors/inserr.i &ErrorNumber     = 32099
                                    &ErrorType       = "EMS"
                                    &ErrorParameters = "c-trad + '~~~~' + '~~~~' + trim(return-value)"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnLastTags DBOProgram 
PROCEDURE returnLastTags :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pNrOrdProd       AS INTEGER.
    DEF INPUT  PARAM pCodEstabelOrd   AS CHARACTER.
    DEF INPUT  PARAM pqtdtags         AS INTEGER.
    DEF INPUT  PARAM pindsitagrupador LIKE wm-etiqueta.ind-sit-agrupador.
    DEF OUTPUT PARAM TABLE FOR  ttWm-Etiqueta-Number. 
    
    DEF VAR i-qtd-etiqueta          AS INTEGER.
    assign i-qtd-etiqueta = 0.
    
    FOR EACH  ttWm-Etiqueta-Number:
        DELETE  ttWm-Etiqueta-Number.
    END.


    FOR EACH wm-etiqueta USE-INDEX idx-wm-etiqueta7
        WHERE wm-etiqueta.nr-ord-prod          = pNrOrdProd     
          AND wm-etiqueta.cod-estabel-ord      = pCodEstabelOrd 
          AND wm-etiqueta.ind-leitura-etiqueta <> 3 /* <> de inutilizada */
          AND wm-etiqueta.ind-sit-agrupador    = pindsitagrupador
           NO-LOCK by  wm-etiqueta.id-etiqueta descending:
           
        
            CREATE  ttWm-Etiqueta-Number.
            ASSIGN  ttWm-Etiqueta-Number.id-etiqueta       =  wm-etiqueta.id-etiqueta.

        assign i-qtd-etiqueta =  i-qtd-etiqueta + 1.
        if  i-qtd-etiqueta = pqtdtags 
        then leave.

    END.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQtdTag DBOProgram 
PROCEDURE returnQtdTag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pNrOrdProd     AS INTEGER.
    DEF INPUT  PARAM pCodEstabelOrd AS CHARACTER.
    DEF OUTPUT PARAM pqtdtag        AS INTEGER.
    
    DEF VAR i-qtd-etiqueta          AS INTEGER.
 
    ASSIGN i-qtd-etiqueta   = 0.
    FOR EACH wm-etiqueta USE-INDEX idx-wm-etiqueta7
       WHERE wm-etiqueta.nr-ord-prod          = pNrOrdProd     
         AND wm-etiqueta.cod-estabel-ord      = pCodEstabelOrd 
         AND wm-etiqueta.ind-leitura-etiqueta = 2               /* lida                                       */  
         AND wm-etiqueta.ind-sit-agrupador   <> 2 NO-LOCK:      /* Somente as n∆o agrupa e agrupador pr¢prio  */  
        
      ASSIGN i-qtd-etiqueta = i-qtd-etiqueta + 1.
        
    END.    

    ASSIGN pqtdtag = i-qtd-etiqueta.
    
    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnValueStandard DBOProgram 
PROCEDURE returnValueStandard :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAMETER pIdEtiqueta      LIKE wm-etiqueta.id-etiqueta       NO-UNDO.
    DEF OUTPUT PARAMETER plog             as logical initial no.
    
    FIND FIRST wm-etiqueta WHERE 
        wm-etiqueta.id-etiqueta       = pIdEtiqueta      AND
        wm-etiqueta.ind-sit-agrupador > 1 NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-agrupador AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta_Agrupador" *}
        ASSIGN c-lbl-liter-etiqueta-agrupador = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-agrupador"}
        ASSIGN plog = NO.
        RETURN "NOK":U.
    END.

    FIND FIRST wm-local
         WHERE wm-local.cod-estabel      = wm-etiqueta.cod-estabel AND
               wm-local.log-local-padrao = YES NO-LOCK NO-ERROR.
    
    FIND FIRST wm-item-embalagem-local 
         WHERE wm-item-embalagem-local.cod-estabel   = wm-etiqueta.cod-estabel   AND
               wm-item-embalagem-local.cod-local     = wm-local.cod-local        AND
               wm-item-embalagem-local.cod-item      = wm-etiqueta.cod-item      AND
               wm-item-embalagem-local.cod-embalagem = wm-etiqueta.cod-embalagem NO-LOCK NO-ERROR.

     IF NOT AVAIL wm-item-embalagem-local THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-item-local AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem_Item_Local" *}
        ASSIGN c-lbl-liter-embalagem-item-local = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-item-local"}
        ASSIGN plog = NO.
        RETURN "NOK":U.
    END.   

    IF wm-item-embalagem-local.qtd-item-emb < wm-etiqueta.qtd-item THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26741"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        ASSIGN plog = NO.
        RETURN "NOK":U.
    END.

    IF wm-item-embalagem-local.qtd-item-emb > wm-etiqueta.qtd-item THEN DO:
        ASSIGN plog = NO.
        RETURN "OK":U.
    END.        
         
    ASSIGN plog = YES.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAgrupador DBOProgram 
PROCEDURE setConstraintAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-id-etiqueta LIKE Wm-etiqueta.id-etiqueta NO-UNDO.

ASSIGN i-id-etiqueta = p-id-etiqueta.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCarga DBOProgram 
PROCEDURE setConstraintCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-id-carga LIKE Wm-carga.id-carga NO-UNDO.

ASSIGN i-id-carga = p-id-carga.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCompCarga DBOProgram 
PROCEDURE setConstraintCompCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id-carga LIKE Wm-carga.id-carga NO-UNDO.
    
    ASSIGN i-id-carga = p-id-carga.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEtiquetas DBOProgram 
PROCEDURE setConstraintEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-cod-item        LIKE Wm-etiqueta.cod-item        NO-UNDO.
DEF INPUT PARAM p-cod-refer       LIKE Wm-etiqueta.cod-refer       NO-UNDO.
DEF INPUT PARAM p-cod-lote        LIKE Wm-etiqueta.cod-lote        NO-UNDO.
DEF INPUT PARAM p-nr-ord-prod     LIKE Wm-etiqueta.nr-ord-prod     NO-UNDO.
DEF INPUT PARAM p-cod-estabel     LIKE Wm-etiqueta.cod-estabel     NO-UNDO.
DEF INPUT PARAM p-cod-estabel-ord LIKE Wm-etiqueta.cod-estabel-ord NO-UNDO.

ASSIGN c-cod-item        = p-cod-item
       c-cod-refer       = p-cod-refer
       c-cod-lote        = p-cod-lote
       i-nr-ord-prod     = p-nr-ord-prod
       c-cod-estabel     = p-cod-estabel
       c-cod-estabel-ord = p-cod-estabel-ord.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nao-agrupa AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-agrupador  AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-proprio    AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-inf-carga  AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-id-carga LIKE Wm-etiqueta.id-carga NO-UNDO.
    
    
    IF p-nao-agrupa THEN 
        ASSIGN i-nao-agrupa = 1.
    ELSE
        ASSIGN i-nao-agrupa = 0.

    IF p-agrupador THEN 
        ASSIGN i-agrupador = 2.
    ELSE
        ASSIGN i-agrupador = 0.

    IF p-proprio THEN 
        ASSIGN i-proprio = 3.
    ELSE
        ASSIGN i-proprio = 0.
    

    ASSIGN de-id-carga  = p-id-carga
           l-inf-carga  = p-inf-carga.
    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOP DBOProgram 
PROCEDURE setConstraintOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel-ord LIKE Wm-etiqueta.cod-estabel-ord NO-UNDO.
    DEF INPUT PARAM p-nr-ord-prod     LIKE Wm-etiqueta.nr-ord-prod NO-UNDO.
    
    ASSIGN c-cod-estabel-ord = p-cod-estabel-ord
           i-nr-ord-prod     = p-nr-ord-prod.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-nao-agrupa AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-agrupador  AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-proprio    AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-id-etiqueta-ini  LIKE Wm-etiqueta.id-etiqueta NO-UNDO.
DEF INPUT PARAM p-id-etiqueta-fim  LIKE Wm-etiqueta.id-etiqueta NO-UNDO.

IF p-nao-agrupa THEN 
    ASSIGN i-nao-agrupa = 1.
ELSE
    ASSIGN i-nao-agrupa = 0.

IF p-agrupador THEN 
    ASSIGN i-agrupador = 2.
ELSE
    ASSIGN i-agrupador = 0.

IF p-proprio THEN 
    ASSIGN i-proprio = 3.
ELSE
    ASSIGN i-proprio = 0.
    
ASSIGN i-id-etiqueta-ini = p-id-etiqueta-ini
       i-id-etiqueta-fim = p-id-etiqueta-fim.    
    
RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom2 DBOProgram 
PROCEDURE setConstraintZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEF INPUT PARAM p-id-carga         LIKE Wm-etiqueta.id-carga NO-UNDO.
        DEF INPUT PARAM p-id-etiqueta-ini  LIKE Wm-etiqueta.id-etiqueta NO-UNDO.
        DEF INPUT PARAM p-id-etiqueta-fim  LIKE Wm-etiqueta.id-etiqueta NO-UNDO.

        ASSIGN i-id-carga        = p-id-carga 
                i-id-etiqueta-ini = p-id-etiqueta-ini
               i-id-etiqueta-fim = p-id-etiqueta-fim. 
        
        RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLidaEstornoRep DBOProgram 
PROCEDURE setLidaEstornoRep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  O mÇtodo consiste em setar para "lido para estorno" as etiquetas que j† foram 
  reportadas Ö produá∆o para que se possa identificar especificamente o que deve 
  ser estornado. Sempre Ç estornado todo um agrupador, e n∆o etiquetas agrupadas 
  (itens): como s∆o reportados os agrupadores (pallets fechados), no caso de 
  estorno h† necessidade de geraá∆o de nova etiqueta agrupadora caso haja 
  manutená∆o nos itens agrupados. Desta forma, garante-se a integridade do processo. 
  Em s°ntese: o processo de reabertura de um pallet s¢ acontece com o pallet 
  n∆o reportado. 
  
  S¢ poder∆o serem lidas as etiquetas agrupadoras que j† estiverem sido reportadas 
  e que n∆o estejam associadas a nenhuma carga.

  Obs.: Todas as etiquetas que pertencerem ao agrupador lido, tambÇm receber∆o 
  o status de lido para estorno. 

  
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pSerial AS DECIMAL. 
    
    DEF VAR c-etiqueta AS CHAR NO-UNDO.

    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta = pSerial 
        EXCLUSIVE-LOCK NO-ERROR.


    IF AVAIL wm-etiqueta THEN DO:
        
        ASSIGN c-etiqueta = STRING(wm-etiqueta.id-etiqueta).

        /* Se n∆o foi reportada */   
        IF NOT wm-etiqueta.log-reportada THEN DO:

            {method/svc/errors/inserr.i
                &ErrorNumber="26078"
                &ErrorType="EMS"
                &ErrorParameters="c-etiqueta"}
            
            RELEASE wm-etiqueta.
            RETURN "NOK":U.
        END.
     
        /* Se n∆o for etiqueta agrupadora */   
        IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO:

            {method/svc/errors/inserr.i
                &ErrorNumber="26079"
                &ErrorType="EMS"
                &ErrorParameters="c-etiqueta"}
            RELEASE wm-etiqueta.
            RETURN "NOK":U.
        END.
        
        /* Se j† estiver vinculado a uma carga  */
        IF wm-etiqueta.id-carga <> 0 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26009"
                &ErrorType="EMS"
                &ErrorParameters="c-etiqueta"}
            RELEASE wm-etiqueta.
            RETURN "NOK":U.
        END.
        
        IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:  /* Agrupador de Etiquetas */
            /* Atualiza as etiquetas de itens  */
            FOR EACH bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 WHERE
                bf{&tablename}.ind-sit-agrupador = 1 AND   /* N∆o agrupa */
                bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta 
                EXCLUSIVE-LOCK:
                
                ASSIGN bf{&tablename}.ind-sit-estorno = 2.
                
            END.
        
        END.
        ASSIGN wm-etiqueta.ind-sit-estorno = 2.
        
    END.
    
    ELSE DO:        
        ASSIGN c-etiqueta = STRING(pSerial).  

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-18 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-18 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-18 + ' ' + c-etiqueta "}
        RELEASE wm-etiqueta.    
        RETURN "NOK":U.
    END.

    RELEASE wm-etiqueta.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAllSonReportada DBOProgram 
PROCEDURE updateAllSonReportada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pIdEtiqueta   AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER pLogReportada AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pSitProcesso  AS INTEGER NO-UNDO.
    
    CASE pSitProcesso:
        WHEN 1 THEN DO: /* Alteracao */
            FOR EACH  bf{&TableName} USE-INDEX idx-wm-etiqueta9 
                WHERE bf{&tablename}.id-agrupador      = pIdEtiqueta AND
                      bf{&tablename}.ind-sit-agrupador = 1           EXCLUSIVE-LOCK:
                ASSIGN bf{&TableName}.log-reportada = pLogReportada.          
            END.
        END.
        WHEN 2 THEN DO: /* Exclusao  */
            ASSIGN pLogReportada = NO.
            FOR EACH  bf{&TableName} USE-INDEX idx-wm-etiqueta9 
                WHERE bf{&tablename}.id-agrupador      = pIdEtiqueta AND
                      bf{&tablename}.ind-sit-agrupador = 1           EXCLUSIVE-LOCK:
                ASSIGN bf{&TableName}.log-reportada = pLogReportada.          
            END.        
        END.
    END CASE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateID DBOProgram 
PROCEDURE updateID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-id-etiqueta   like wm-etiqueta.id-etiqueta no-undo.
def input param p-id-carga      like wm-etiqueta.id-carga    no-undo.

find first wm-etiqueta where
     wm-etiqueta.id-etiqueta = p-id-etiqueta exclusive-lock no-error.
if avail wm-etiqueta then do:
    assign wm-etiqueta.id-carga = p-id-carga.
    /* Atualiza as etiquetas de itens  */
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN
        FOR EACH bf{&TableName} USE-INDEX IDX-WM-ETIQUETA9 WHERE
            bf{&tablename}.ind-sit-agrupador = 1 AND   /* N∆o agrupa */
            bf{&tablename}.id-agrupador      = wm-etiqueta.id-etiqueta 
            EXCLUSIVE-LOCK:
            
            ASSIGN bf{&tablename}.id-carga    = p-id-Carga.
            
        END.    
    RELEASE wm-etiqueta.
end.
else
    RETURN "NOK":U.

RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateStatusBloqueioSerial DBOProgram 
PROCEDURE updateStatusBloqueioSerial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:
  - pBloqueia: se valor YES bloqueara a etiqueta
               se valor NO  liberara  a etiqueta
  - pOrigemBloqueio:
        (1) Producao
        (2) Recebimento
        (3) Inventario
        (4) Manual               
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pRwEtiqueta     AS ROWID                     NO-UNDO.
    DEFINE INPUT PARAMETER pOrigemBloqueio AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER pMotivo         AS CHARACTER FORMAT "X(50)"  NO-UNDO.
    DEFINE INPUT PARAMETER pBloqueia       AS LOGICAL                   NO-UNDO.

    DEFINE VARIABLE c-valores AS CHARACTER NO-UNDO.

    IF pBloqueia THEN DO:
        FIND FIRST bf{&TableName}
             WHERE ROWID(bf{&TableName}) = pRwEtiqueta NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:
            IF bf{&tablename}.ind-leitura-etiqueta <> 5 THEN DO:

                /** Seta Status da Etiqueta para BLOQUEADO **/
                FIND CURRENT bf{&TableName} EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN bf{&tablename}.ind-leitura-etiqueta = 5.
                FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.

                /** Criacao de Historico Bloqueio Etiqueta **/
                CREATE wm-histor-bloq-etiq.
                ASSIGN wm-histor-bloq-etiq.id-etiqueta                 = bf{&tablename}.id-etiqueta
                       wm-histor-bloq-etiq.dat-bloq-etiq               = TODAY
                       wm-histor-bloq-etiq.hra-bloq-etiq               = TIME
                       wm-histor-bloq-etiq.idi-orig-bloq               = pOrigemBloqueio
                       SUBSTRING(wm-histor-bloq-etiq.cod-livre-1,1,50) = pMotivo.

                RUN getUsuario IN THIS-PROCEDURE (OUTPUT wm-histor-bloq-etiq.cod-usuar-bloq).
            END.
            ELSE RETURN "NOK":U.
        END.
        ELSE RETURN "NOK":U.
    END.
    ELSE DO:
        FIND FIRST bf{&TableName}
             WHERE ROWID(bf{&TableName}) = pRwEtiqueta NO-LOCK NO-ERROR.
        
        IF AVAIL bf{&TableName} THEN DO:
            IF bf{&tablename}.ind-leitura-etiqueta = 5 THEN DO:
                
                /** Seta Status da Etiqueta para LIDO **/
                FIND CURRENT bf{&TableName} EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN bf{&tablename}.ind-leitura-etiqueta = 2.
                FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.

                /** Atualiza Historico Bloqueio Etiqueta **/
                FIND FIRST wm-histor-bloq-etiq
                     WHERE wm-histor-bloq-etiq.id-etiqueta  = bf{&tablename}.id-etiqueta AND 
                           wm-histor-bloq-etiq.log-liberada = NO /** Nao Liberada **/    EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL wm-histor-bloq-etiq THEN DO:                    
                    ASSIGN wm-histor-bloq-etiq.dat-liber-etiq               = TODAY
                           wm-histor-bloq-etiq.hra-libera-etiq              = TIME
                           wm-histor-bloq-etiq.log-liberada                 = YES
                           SUBSTRING(wm-histor-bloq-etiq.cod-livre-1,51,50) = pMotivo.
                    
                    RUN getUsuario IN THIS-PROCEDURE (OUTPUT wm-histor-bloq-etiq.cod-usuar-libera-etiq).    
                END.
                ELSE RETURN "NOK":U.
            END.
            ELSE RETURN "NOK":U.
        END.
        ELSE RETURN "NOK":U.
    END.
    
    &IF "{&mgscm_version}":U >= "2.07" &THEN
        FIND FIRST wm-histor-bloq-etiq
            WHERE wm-histor-bloq-etiq.id-etiqueta  = bf{&tablename}.id-etiqueta EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL wm-histor-bloq-etiq THEN DO:
            IF wm-histor-bloq-etiq.log-liberada = YES THEN DO: /** Liberada **/ 
                RUN wmp/wm9414.p (INPUT Rowid (wm-histor-bloq-etiq),
                                  INPUT 9, /*desbloqueio etiqueta*/
                                  INPUT wm-histor-bloq-etiq.id-etiqueta,
                                  INPUT c-seg-usuario,
                                  INPUT Wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado,
                                  OUTPUT TABLE RowErrors).

                IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN
                            RETURN "NOK":U.
            END.
            ELSE DO:
                RUN wmp/wm9414.p (INPUT Rowid (wm-histor-bloq-etiq),
                                  INPUT 8, /*bloqueio etiqueta*/
                                  INPUT wm-histor-bloq-etiq.id-etiqueta,
                                  INPUT c-seg-usuario,
                                  INPUT Wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado,
                                  OUTPUT TABLE RowErrors).

                IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN
                            RETURN "NOK":U.
            END.
        END.
    &ENDIF

    /********************* Chamada EPC *********************/    
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

    ASSIGN c-valores = STRING(pRwEtiqueta)     + ";" +
                       STRING(pMotivo)         + ";" +
                       STRING(pBloqueia).

    /* Criacao da Temp-Table tt-epc */
    {include/i-epc200.i2 &CodEvent='"Bloqueio-Serial-GE-DAKO"'
                         &CodParameter='"Bloqueio-Serial-DAKO"'
                         &ValueParameter="STRING(c-valores)"} 

    /* Chamada EPC */
    {include/i-epc201.i "Bloqueio-Serial-GE-DAKO"}

    /* Criacao de Erros (RowErrors) conforme tt-epc  */
    FOR EACH  tt-epc 
        WHERE tt-epc.cod-parameter = "NOK":U NO-LOCK:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = INTEGER(ENTRY(1,tt-epc.val-parameter,";"))
               RowErrors.ErrorNumber      = INTEGER(ENTRY(2,tt-epc.val-parameter,";")) 
               RowErrors.ErrorDescription = ENTRY(3,tt-epc.val-parameter,";")
               RowErrors.ErrorParameters  = ENTRY(4,tt-epc.val-parameter,";")
               RowErrors.ErrorType        = ENTRY(5,tt-epc.val-parameter,";")
               RowErrors.ErrorHelp        = ENTRY(6,tt-epc.val-parameter,";")
               RowErrors.ErrorSubType     = ENTRY(7,tt-epc.val-parameter,";").
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN
        RETURN "NOK":U.

    /******************* Fim Chamada EPC *******************/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAgrupCarga DBOProgram 
PROCEDURE validaAgrupCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    
  O mÇtodo consiste em  validar se um determinado serial lido pode ou n∆o ser 
  agrup†do a uma carga. S¢ ser† poss°vel a  associaá∆o de uma etiqueta que j† 
  tenha sido reportada e que n∆o  esteja associada a nenhuma outra carga. 
    
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pCodUsuario AS CHARACTER.
    DEF INPUT PARAM pSerialAgrup AS DECIMAL.
    
    DEF VAR c-agrupador AS CHAR NO-UNDO.
    
    ASSIGN c-agrupador = STRING(pSerialAgrup).

    
    FIND FIRST usuario-scm WHERE
        usuario-scm.usuario = pCodUsuario NO-LOCK NO-ERROR.
        
    IF NOT AVAIL usuario-scm THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario-3 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-usuario-3"}
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF NOT usuario-scm.log-utiliza-coletor THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26068"
                &ErrorType="EMS"
                &ErrorParameters="pCodUsuario"}

            RETURN "NOK":U.
        END.
    END.
    
    FIND FIRST wm-etiqueta 
        WHERE wm-etiqueta.id-etiqueta = pSerialAgrup 
        NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-19 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-19 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-19"}
        RETURN "NOK":U.
    END.
    
    /*******************************************************************
    ** Consistencia que verifica se alguma Etiqueta Nao Agrupa (Item) **
    ** do pallet ao qual deseja-se associar a carga, esta relacionada **
    ** a uma outra carga.                                             **
    *******************************************************************/
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:
        FIND FIRST b-wm-etiqueta
             WHERE b-wm-etiqueta.id-agrupador = wm-etiqueta.id-etiqueta AND
                   b-wm-etiqueta.id-carga    <> 0                       AND
                   b-wm-etiqueta.id-carga    <> wm-etiqueta.id-carga    NO-LOCK NO-ERROR.

        IF AVAIL b-wm-etiqueta THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="28408"
                &ErrorType="EMS"
                &ErrorParameters="STRING(b-wm-etiqueta.id-etiqueta) + '~~~~' + STRING(b-wm-etiqueta.id-carga) + '~~~~' + STRING(wm-etiqueta.id-etiqueta)"}
            RETURN "NOK":U.
        END.
    END.
    
    IF wm-etiqueta.id-carga <> 0  THEN DO:  /* J† associado a uma carga */
        {method/svc/errors/inserr.i
            &ErrorNumber="26011"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.
 

    IF NOT wm-etiqueta.log-reportada THEN DO:  /* N∆o reportada Ö produá∆o */
        {method/svc/errors/inserr.i
            &ErrorNumber="26086"
            &ErrorType="EMS"
            &ErrorParameters="c-agrupador"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiqueta DBOProgram 
PROCEDURE validaEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pIdEtiqueta      LIKE wm-etiqueta.id-etiqueta       NO-UNDO.
    DEF INPUT PARAMETER pIndSitAgrupador LIKE wm-etiqueta.ind-sit-agrupador NO-UNDO.
    
    FIND FIRST wm-etiqueta WHERE 
        wm-etiqueta.id-etiqueta       = pIdEtiqueta      AND
        wm-etiqueta.ind-sit-agrupador = pIndSitAgrupador NO-LOCK NO-ERROR.
    
    IF NOT AVAIL wm-etiqueta THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-20 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-20 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-20"}
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaDocto DBOProgram 
PROCEDURE validaEtiquetaDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estabel LIKE wm-docto.cod-estabel    NO-UNDO.
    DEF INPUT  PARAM p-cod-local   LIKE wm-docto.cod-local      NO-UNDO.
    DEF INPUT  PARAM p-id-docto    LIKE wm-docto.id-docto       NO-UNDO.
    DEF INPUT  PARAM p-id-etiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    DEF VAR i-id-carga  LIKE wm-carga.id-carga NO-UNDO.
    
    FIND FIRST wm-docto 
        WHERE wm-docto.cod-estabel = p-cod-estabel
          AND wm-docto.cod-local   = p-cod-local 
          AND wm-docto.id-docto = p-id-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-2 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-2"}
        RETURN "NOK":U.
    END.

    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-21 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-21 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-21"}
        RETURN "NOK":U.
    END.

    RUN getCarga IN THIS-PROCEDURE (input  p-cod-estabel,
                                    input  p-cod-local,
                                    INPUT  p-id-docto,
                                    OUTPUT i-id-carga).

    IF i-id-carga = 0 THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-carga-5 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Carga" *}
        ASSIGN c-lbl-liter-carga-5 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-carga-5"}
        RETURN "NOK":U.
    END.
    
    FIND FIRST wm-etiqueta WHERE 
        wm-etiqueta.id-etiqueta = p-id-etiqueta AND
        wm-etiqueta.id-carga    = i-id-carga NO-LOCK NO-ERROR.
        
    IF NOT AVAIL wm-etiqueta THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26417"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaMovto DBOProgram 
PROCEDURE validaEtiquetaMovto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       O mÇtodo tem por objetivo validar se um serial lido pertence
               a um determinado movimento do documento.
------------------------------------------------------------------------------*/
    
    DEF INPUT  PARAM p-id-etiqueta    LIKE wm-etiqueta.id-etiqueta     NO-UNDO.
    DEF INPUT  PARAM p-id-docto       LIKE wm-docto.id-docto           NO-UNDO.
    DEF INPUT  PARAM p-num-seq-item   LIKE wm-docto-itens.num-seq-item NO-UNDO.
    DEF INPUT  PARAM p-id-movto       LIKE wm-box-movto.id-movto       NO-UNDO.
    DEF INPUT  PARAM p-ind-tipo-movto LIKE wm-box-movto.ind-tipo-movto NO-UNDO.
    DEF OUTPUT PARAM p-cod-item       LIKE wm-etiqueta.cod-item        NO-UNDO.
    DEF OUTPUT PARAM p-cod-embalagem  LIKE wm-etiqueta.cod-embalagem   NO-UNDO.
    
    
    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-22 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-22 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-22"}
        RETURN "NOK":U.
    END.
    
    ASSIGN p-cod-item      = wm-etiqueta.cod-item
           p-cod-embalagem = wm-etiqueta.cod-embalagem.
    
    
    FIND FIRST wm-docto WHERE 
         wm-docto.id-docto    = p-id-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-3"}
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-docto-itens WHERE
        wm-docto-itens.cod-estabel  = wm-docto.cod-estabel AND
        wm-docto-itens.cod-local    = wm-docto.cod-local   AND
        wm-docto-itens.id-docto     = p-id-docto AND 
        wm-docto-itens.num-seq-item = p-num-seq-item NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:  
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-do-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_do_Documento" *}
        ASSIGN c-lbl-liter-item-do-documento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-do-documento"}
        RETURN "NOK":U.
    END.
    
    
    /* Validar se a etiqueta est† atendendo a um item sob encomenda no armazenamento */
    IF wm-docto-itens.log-item-sob-enc-rec = YES THEN DO:
        FIND FIRST wm-docto-itens-ped WHERE
            wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel  AND
            wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local    AND
            wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto     AND
            wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
        IF AVAIL wm-docto-itens-ped THEN DO:    
            IF wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli OR
                wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev THEN DO:
                
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-etiqueta-23 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Etiqueta" *}
                ASSIGN c-lbl-liter-etiqueta-23 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26427"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-etiqueta-23"}
                RETURN "NOK":U.
            END.
            
        END.
    END.

    /* Validar se a etiqueta est† atendendo a um item sob encomenda  na sa°da*/
    IF wm-docto.ind-tipo-trans  <>  1  /* entrada */
    THEN 
            FIND FIRST wm-docto-itens-ped 
             WHERE wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel   
               AND wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local     
               AND wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto      
               AND wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
             IF AVAIL wm-docto-itens-ped AND wm-docto-itens-ped.log-ped-sob-encomenda
             THEN DO: IF    wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli 
                         OR wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev
                      THEN DO:
                                 /* Inicio -- Projeto Internacional */
                                 DEFINE VARIABLE c-lbl-liter-etiqueta-24 AS CHARACTER NO-UNDO.
                                 {utp/ut-liter.i "Etiqueta" *}
                                 ASSIGN c-lbl-liter-etiqueta-24 = TRIM(RETURN-VALUE).
                                 {method/svc/errors/inserr.i
                                     &ErrorNumber="26427"
                                     &ErrorType="EMS"
                                     &ErrorParameters="c-lbl-liter-etiqueta-24"}
                                 RETURN "NOK":U.
                            END.
         
                    END.
 
    
    FIND FIRST wm-box-movto WHERE 
        wm-box-movto.cod-estabel    = wm-docto.cod-estabel AND
        wm-box-movto.cod-local      = wm-docto.cod-local   AND
        wm-box-movto.id-docto       = p-id-docto      AND
        wm-box-movto.num-seq-item   = p-num-seq-item  AND    
        wm-box-movto.id-movto       = p-id-movto      AND 
        wm-box-movto.ind-tipo-movto = p-ind-tipo-movto NO-LOCK NO-ERROR. /* 1-entrada 2-sa°da */
        
    IF NOT AVAIL wm-box-movto THEN DO:       
       /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-movimento-do-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Movimento_do_Documento" *}
        ASSIGN c-lbl-liter-movimento-do-documento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-movimento-do-documento"}
        RETURN "NOK":U.
    END.
    
    IF wm-box-movto.log-picking AND
       wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem" *}
        ASSIGN c-lbl-liter-embalagem-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-4"}
        RETURN "NOK":U.
    END.
         
    IF wm-etiqueta.cod-item <> wm-docto-itens.cod-item THEN DO:
       /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-2"}
        RETURN "NOK":U.
    END.
    
    IF p-id-movto = 1 THEN DO: /* Entrada */
        IF wm-etiqueta.cod-lote <> wm-docto-itens.cod-lote THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-lote AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Lote" *}
            ASSIGN c-lbl-liter-lote = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="26427"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-lote"}
            RETURN "NOK":U.
        END.
    END.
         
    IF wm-etiqueta.cod-refer <> wm-docto-itens.cod-refer THEN DO:
         /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-referencia AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Referºncia" *}
        ASSIGN c-lbl-liter-referencia = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-referencia"}
        RETURN "NOK":U.
    END.
     
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaMovtoArmaz DBOProgram 
PROCEDURE validaEtiquetaMovtoArmaz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       O mÇtodo tem por objetivo validar se um serial lido pertence
               a um determinado movimento do documento.
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-estabel         LIKE wm-docto.cod-estabel        NO-UNDO.
    DEF INPUT  PARAM p-cod-local           LIKE wm-docto.cod-local          NO-UNDO.    
    DEF INPUT  PARAM p-id-etiqueta         LIKE wm-etiqueta.id-etiqueta     NO-UNDO.
    DEF INPUT  PARAM p-id-docto            LIKE wm-docto.id-docto           NO-UNDO.
    DEF INPUT  PARAM p-num-seq-item        LIKE wm-docto-itens.num-seq-item NO-UNDO.
    DEF INPUT  PARAM p-id-movto            LIKE wm-box-movto.id-movto       NO-UNDO.
    DEF INPUT  PARAM p-ind-tipo-movto      LIKE wm-box-movto.ind-tipo-movto NO-UNDO.
    DEF INPUT  PARAM TABLE FOR ttSerialQtd.
    DEF OUTPUT PARAM p-cod-item            LIKE wm-etiqueta.cod-item        NO-UNDO.
    DEF OUTPUT PARAM p-cod-embalagem       LIKE wm-etiqueta.cod-embalagem   NO-UNDO.
    DEF OUTPUT PARAM p-qtd-item-disponivel LIKE wm-etiqueta.qtd-item        NO-UNDO.
    
    DEFINE VARIABLE de-qtd-total-retirada AS DECIMAL INITIAL 0 NO-UNDO.

    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-25 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-25 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-25"}
        RETURN "NOK":U.
    END.
    
    ASSIGN p-cod-item            = wm-etiqueta.cod-item
           p-cod-embalagem       = wm-etiqueta.cod-embalagem
           p-qtd-item-disponivel = wm-etiqueta.qtd-item  - wm-etiqueta.qtd-item-retirado.
    
    FIND FIRST ttSerialQtd WHERE
        ttSerialQtd.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    
    /* Valida se a etiqueta j† foi digitada */
    IF AVAIL ttSerialQtd THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26004"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.ind-sit-agrupador  = 1 THEN DO:     /* N∆o Agrupador */
        
        /* Verifica se o item n∆o pertence a um agrupador fechado */
        IF wm-etiqueta.id-agrupador <> 0 THEN DO:
            FIND FIRST bf{&TableName} WHERE 
                bf{&tablename}.id-etiqueta = wm-etiqueta.id-agrupador NO-LOCK NO-ERROR.
                
            IF NOT AVAIL bf{&TableName} THEN DO:
                
                 /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-agrupador-da-etiqueta-informad AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Agrupador_da_etiqueta_informada" *}
                ASSIGN c-lbl-liter-agrupador-da-etiqueta-informad = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-agrupador-da-etiqueta-informad"}
                RETURN "NOK":U.
            END.
            
            IF bf{&TableName}.qtd-item-retirado = 0 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="26664"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
                
            END.
        
        END.
    
    END.
    
    IF wm-etiqueta.ind-sit-agrupador  = 2 AND
       wm-etiqueta.qtd-item-retirado <> 0 THEN DO:  /* Agrupador de etiquetas aberto */

        {method/svc/errors/inserr.i
            &ErrorNumber="26657"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.
    
    FIND FIRST wm-docto WHERE 
        wm-docto.cod-estabel = p-cod-estabel AND
        wm-docto.cod-local   = p-cod-local   AND
        wm-docto.id-docto    = p-id-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-4"}
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-docto-itens WHERE
        wm-docto-itens.cod-estabel  = wm-docto.cod-estabel AND
        wm-docto-itens.cod-local    = wm-docto.cod-local AND
        wm-docto-itens.id-docto     = p-id-docto AND 
        wm-docto-itens.num-seq-item = p-num-seq-item NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:        
         /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-do-documento-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_do_Documento" *}
        ASSIGN c-lbl-liter-item-do-documento-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-do-documento-2"}
        RETURN "NOK":U.
    END.
        
    /* Validar se a etiqueta est† atendendo a um item sob encomenda no armazenamento */
    IF wm-docto-itens.log-item-sob-enc-rec = YES THEN DO:
        FIND FIRST wm-docto-itens-ped WHERE
            wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel  AND
            wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local    AND
            wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto     AND
            wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
        IF AVAIL wm-docto-itens-ped THEN DO:    
            IF wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli OR
                wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev THEN DO:
                
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-etiqueta-26 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Etiqueta" *}
                ASSIGN c-lbl-liter-etiqueta-26 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26427"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-etiqueta-26"}
                RETURN "NOK":U.
            END.
            
        END.
    END.

    /* Validar se a etiqueta est† atendendo a um item sob encomenda  na sa°da*/
    IF wm-docto.ind-tipo-trans  <>  1  /* entrada */
    THEN 
            FIND FIRST wm-docto-itens-ped 
             WHERE wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel   
               AND wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local     
               AND wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto      
               AND wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
             IF AVAIL wm-docto-itens-ped AND wm-docto-itens-ped.log-ped-sob-encomenda
             THEN DO: IF    wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli 
                         OR wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev
                      THEN DO:
                                 /* Inicio -- Projeto Internacional */
                                 DEFINE VARIABLE c-lbl-liter-etiqueta-27 AS CHARACTER NO-UNDO.
                                 {utp/ut-liter.i "Etiqueta" *}
                                 ASSIGN c-lbl-liter-etiqueta-27 = TRIM(RETURN-VALUE).
                                 {method/svc/errors/inserr.i
                                     &ErrorNumber="26427"
                                     &ErrorType="EMS"
                                     &ErrorParameters="c-lbl-liter-etiqueta-27"}
                                 RETURN "NOK":U.
                            END.
         
                    END.         
    
    FIND FIRST wm-box-movto 
         WHERE wm-box-movto.cod-estabel    = wm-docto.cod-estabel AND
               wm-box-movto.cod-local      = wm-docto.cod-local   AND
               wm-box-movto.id-docto       = p-id-docto           AND
               wm-box-movto.num-seq-item   = p-num-seq-item       AND    
               wm-box-movto.id-movto       = p-id-movto           AND 
               wm-box-movto.ind-tipo-movto = p-ind-tipo-movto NO-LOCK NO-ERROR. /* 1-entrada 2-sa°da */
        
    IF NOT AVAIL wm-box-movto THEN DO:       
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-movimento-do-documento-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Movimento_do_Documento" *}
        ASSIGN c-lbl-liter-movimento-do-documento-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-movimento-do-documento-2"}
        RETURN "NOK":U.
    END.

    FOR EACH ttSerialQtd NO-LOCK:
        ASSIGN de-qtd-total-retirada = de-qtd-total-retirada + ttSerialQtd.qtd-item-retirado.
    END.
    
    IF de-qtd-total-retirada > (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="27851"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.            
    END. 

    IF p-qtd-item-disponivel <> (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="53908"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.

    IF wm-box-movto.log-picking AND
       wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-5 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem" *}
        ASSIGN c-lbl-liter-embalagem-5 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-5"}
        RETURN "NOK":U.
    END.
         
    IF wm-etiqueta.cod-item <> wm-docto-itens.cod-item THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-3"}
        RETURN "NOK":U.
    END.
    
    IF wm-box-movto.ind-tipo-movto = 1 THEN DO: /* Entrada */
        IF wm-etiqueta.cod-lote <> wm-docto-itens.cod-lote THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-lote-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Lote" *}
            ASSIGN c-lbl-liter-lote-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="26427"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-lote-2"}
            RETURN "NOK":U.
        END.
    END.
         
    IF wm-etiqueta.cod-refer <> wm-docto-itens.cod-refer THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-referencia-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Referància" *}
        ASSIGN c-lbl-liter-referencia-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-referencia-2"}
        RETURN "NOK":U.
    END.
     
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaMovtoDocto DBOProgram 
PROCEDURE validaEtiquetaMovtoDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       O mÇtodo tem por objetivo validar se um serial lido pertence
               a um determinado movimento do documento.
------------------------------------------------------------------------------*/
    
    DEF INPUT  PARAM p-id-etiqueta   LIKE wm-etiqueta.id-etiqueta     NO-UNDO.
    DEF INPUT  PARAM p-id-docto      LIKE wm-docto.id-docto           NO-UNDO.
    DEF INPUT  PARAM p-num-seq-item  LIKE wm-docto-itens.num-seq-item NO-UNDO.
    DEF INPUT  PARAM p-id-movto      LIKE wm-box-movto.id-movto       NO-UNDO.
    
    
    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-28 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-28 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-28"}
        RETURN "NOK":U.
    END.
    
    
    FIND FIRST wm-docto WHERE 
         wm-docto.id-docto = p-id-docto NO-LOCK NO-ERROR.
          
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-5 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-5 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-5"}
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-docto-itens WHERE
        wm-docto-itens.cod-estabel  = wm-docto.cod-estabel and
        wm-docto-itens.cod-local    = wm-docto.cod-local   and
        wm-docto-itens.id-docto     = p-id-docto AND 
        wm-docto-itens.num-seq-item = p-num-seq-item NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:        
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-do-documento-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_do_Documento" *}
        ASSIGN c-lbl-liter-item-do-documento-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-do-documento-3"}
        RETURN "NOK":U.
    END.
    
    FIND FIRST wm-box-movto WHERE 
        wm-box-movto.id-docto       = p-id-docto      AND
        wm-box-movto.num-seq-item   = p-num-seq-item  AND    
        wm-box-movto.id-movto       = p-id-movto      AND 
        wm-box-movto.ind-tipo-movto = 1 /* Entrada */ NO-LOCK NO-ERROR.
        
    IF NOT AVAIL wm-box-movto THEN DO:       
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-movimento-do-documento-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Movimento_do_Documento" *}
        ASSIGN c-lbl-liter-movimento-do-documento-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-movimento-do-documento-3"}
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-embalagem-6 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Embalagem" *}
        ASSIGN c-lbl-liter-embalagem-6 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-embalagem-6"}
        RETURN "NOK":U.
    END.
         
    IF wm-etiqueta.cod-item <> wm-docto-itens.cod-item THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-4"}
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.cod-lote <> wm-docto-itens.cod-lote THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-lote-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Lote" *}
        ASSIGN c-lbl-liter-lote-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-lote-3"}
        RETURN "NOK":U.
    END.
     
    IF wm-etiqueta.cod-refer <> wm-docto-itens.cod-refer THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-referencia-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Referància" *}
        ASSIGN c-lbl-liter-referencia-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-referencia-3"}
        RETURN "NOK":U.
    END.
     
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaMovtoPicking DBOProgram 
PROCEDURE validaEtiquetaMovtoPicking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       O mÇtodo tem por objetivo validar se um serial lido pertence
               a um determinado movimento do documento.
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estabel         LIKE wm-docto.cod-estabel        NO-UNDO.
    DEF INPUT  PARAM p-cod-local           LIKE wm-docto.cod-local          NO-UNDO.
    DEF INPUT  PARAM p-id-etiqueta         LIKE wm-etiqueta.id-etiqueta     NO-UNDO.
    DEF INPUT  PARAM p-id-docto            LIKE wm-docto.id-docto           NO-UNDO.
    DEF INPUT  PARAM p-num-seq-item        LIKE wm-docto-itens.num-seq-item NO-UNDO.
    DEF INPUT  PARAM p-id-movto            LIKE wm-box-movto.id-movto       NO-UNDO.
    DEF INPUT  PARAM p-ind-tipo-movto      LIKE wm-box-movto.ind-tipo-movto NO-UNDO.
    DEF INPUT  PARAM p-qtd-movto-restante  LIKE wm-etiqueta.qtd-item        NO-UNDO.
    DEF INPUT  PARAM TABLE FOR tt-serial-picking.
    DEF OUTPUT PARAM p-cod-item            LIKE wm-etiqueta.cod-item        NO-UNDO.
    DEF OUTPUT PARAM p-cod-embalagem       LIKE wm-etiqueta.cod-embalagem   NO-UNDO.
    DEF OUTPUT PARAM p-qtd-item-disponivel LIKE wm-etiqueta.qtd-item        NO-UNDO.
    
    
    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-29 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-29 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-29"}
        RETURN "NOK":U.
    END.
    
    ASSIGN p-cod-item            = wm-etiqueta.cod-item
           p-cod-embalagem       = wm-etiqueta.cod-embalagem
           p-qtd-item-disponivel = wm-etiqueta.qtd-item  - wm-etiqueta.qtd-item-retirado.
    
    IF p-qtd-item-disponivel <= 0 THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26658"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        RETURN "NOK":U.
    END.
    /** Verifica se a Etiqueta esta Bloqueada **/
    IF wm-etiqueta.ind-leitura-etiqueta = 5 THEN DO:
        {method/svc/errors/inserr.i
                &ErrorNumber="28244"
                &ErrorType="EMS"
                &ErrorParameters="STRING(wm-etiqueta.id-etiqueta)"}
            RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.ind-sit-agrupador  = 2 THEN DO:
        IF wm-etiqueta.qtd-item-retirado <> 0 THEN DO:  /* Agrupador de etiquetas aberto */

            {method/svc/errors/inserr.i
                &ErrorNumber="26657"
                &ErrorType="EMS"
                &ErrorParameters="''"}
            RETURN "NOK":U.
        END.
       
        IF wm-etiqueta.qtd-item-retirado = 0 THEN DO:  /* Agrupador de etiquetas fechado */
            
            IF wm-etiqueta.qtd-item > p-qtd-movto-restante THEN DO:
        
                {method/svc/errors/inserr.i
                    &ErrorNumber="26661"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
            
            END. 
        END.


        FOR EACH bfWm-etiqueta WHERE
            bfWm-etiqueta.id-agrupador = wm-etiqueta.id-etiqueta NO-LOCK:
            
            IF CAN-FIND(FIRST tt-serial-picking WHERE
                tt-serial-picking.id-etiqueta = bfWm-etiqueta.id-etiqueta NO-LOCK) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="26657"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}                
                RETURN "NOK":U.
            END.
            
        END.
        
    END.
    ELSE DO:
        FOR EACH tt-serial-picking:
            IF NOT CAN-FIND(FIRST bfWm-etiqueta WHERE
                bfWm-etiqueta.id-etiqueta       = tt-serial-picking.id-etiqueta AND
                bfWm-etiqueta.ind-sit-agrupador = 2 NO-LOCK) THEN
                NEXT.
            
            FOR EACH bfWm-etiqueta WHERE
                bfWm-etiqueta.id-agrupador = tt-serial-picking.id-etiqueta NO-LOCK:
                IF bfWm-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26660"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}                
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.

    FIND FIRST wm-docto WHERE 
        wm-docto.cod-estabel = p-cod-estabel AND
        wm-docto.cod-local   = p-cod-local   AND
        wm-docto.id-docto    = p-id-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-6 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-6 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-6"}
        RETURN "NOK":U.
    END.
        
    FIND FIRST wm-docto-itens WHERE
        wm-docto-itens.cod-estabel  = wm-docto.cod-estabel AND
        wm-docto-itens.cod-local    = wm-docto.cod-local AND
        wm-docto-itens.id-docto     = p-id-docto AND 
        wm-docto-itens.num-seq-item = p-num-seq-item NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:        
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-do-documento-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_do_Documento" *}
        ASSIGN c-lbl-liter-item-do-documento-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-do-documento-4"}
        RETURN "NOK":U.
    END.    
    
    /* Validar se a etiqueta est  atendendo a um item sob encomenda no armazenamento */
    
    IF wm-docto-itens.log-item-sob-enc-rec = YES THEN DO:
        FIND FIRST wm-docto-itens-ped WHERE
            wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel  AND
            wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local    AND
            wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto     AND
            wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
        IF AVAIL wm-docto-itens-ped THEN DO:    
            IF wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli OR
                wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev THEN DO:
                
               /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-etiqueta-30 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Etiqueta" *}
                ASSIGN c-lbl-liter-etiqueta-30 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26427"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-etiqueta-30"}
                RETURN "NOK":U.
            END.
            
        END.
    END.
    
    /* Validar se a etiqueta est  atendendo a um item sob encomenda  na sa°da*/
    /*
    IF wm-docto.ind-tipo-trans  <>  1  /* entrada */
    THEN 
            FIND FIRST wm-docto-itens-ped 
             WHERE wm-docto-itens-ped.cod-estabel  = wm-docto-itens.cod-estabel   
               AND wm-docto-itens-ped.cod-local    = wm-docto-itens.cod-local     
               AND wm-docto-itens-ped.id-docto     = wm-docto-itens.id-docto      
               AND wm-docto-itens-ped.num-seq-item = wm-docto-itens.num-seq-item NO-LOCK NO-ERROR.
             IF AVAIL wm-docto-itens-ped AND wm-docto-itens-ped.log-ped-sob-encomenda
             THEN DO: IF    wm-etiqueta.nr-pedcli  <> wm-docto-itens-ped.nr-pedcli 
                         OR wm-etiqueta.nome-abrev <> wm-docto-itens-ped.nome-abrev
                      THEN DO:
                                 {method/svc/errors/inserr.i
                                     &ErrorNumber="26427"
                                     &ErrorType="EMS"
                                     &ErrorParameters="'Etiqueta'"}
                                 RETURN "NOK":U.
                            END.
         
                    END.
 
    END.
    
    */
    
    FIND FIRST wm-box-movto WHERE 
        wm-box-movto.cod-estabel    = wm-docto.cod-estabel AND
        wm-box-movto.cod-local      = wm-docto.cod-local  AND 
        wm-box-movto.id-docto       = p-id-docto      AND
        wm-box-movto.num-seq-item   = p-num-seq-item  AND    
        wm-box-movto.id-movto       = p-id-movto      AND 
        wm-box-movto.ind-tipo-movto = p-ind-tipo-movto NO-LOCK NO-ERROR. /* 1-entrada 2-sa°da */
        
    IF NOT AVAIL wm-box-movto THEN DO:       
         /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-movimento-do-documento-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Movimento_do_Documento" *}
        ASSIGN c-lbl-liter-movimento-do-documento-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-movimento-do-documento-4"}
        RETURN "NOK":U.
    END.
    
    IF wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
        /* etiqueta agrupadora */
        IF wm-etiqueta.ind-sit-agrupador <> 1 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embalagem-7 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem-7 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="26427"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-embalagem-7"}
            RETURN "NOK":U.
        END.
        ELSE DO:  /* etiqueta nao agrupa valida embalagem do pai */
            FIND b-wm-etiqueta NO-LOCK
                WHERE b-wm-etiqueta.id-etiqueta = wm-etiqueta.id-agrupador NO-ERROR.
            IF AVAIL b-wm-etiqueta
            AND b-wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-embalagem-8 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Embalagem" *}
                ASSIGN c-lbl-liter-embalagem-8 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="26427"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-embalagem-8"}
                RETURN "NOK":U.
            END.
        END.
    END.
         
    IF wm-etiqueta.cod-item <> wm-docto-itens.cod-item THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-5 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-5 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-item-5"}
        RETURN "NOK":U.
    END.
    
    IF  wm-box-movto.log-picking = NO /* Nao utiliza area de picking */
    AND wm-etiqueta.cod-lote <> wm-box-movto.cod-lote THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-lote-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Lote" *}
            ASSIGN c-lbl-liter-lote-4 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="26427"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-lote-4"}
            RETURN "NOK":U.
    END.
        
    IF wm-etiqueta.cod-refer <> wm-docto-itens.cod-refer THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-referencia-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Referància" *}
        ASSIGN c-lbl-liter-referencia-4 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="26427"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-referencia-4"}
        RETURN "NOK":U.
    END.
     
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaOP DBOProgram 
PROCEDURE validaEtiquetaOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id-etiqueta     LIKE wm-etiqueta.id-etiqueta     NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-ord LIKE wm-etiqueta.cod-estabel-ord NO-UNDO.
    DEF INPUT PARAM p-nr-ord-prod     LIKE wm-etiqueta.nr-ord-prod     NO-UNDO.
    
    
    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta     = p-id-etiqueta     AND
        wm-etiqueta.cod-estabel-ord = p-cod-estabel-ord AND
        wm-etiqueta.nr-ord-prod     = p-nr-ord-prod     NO-LOCK NO-ERROR.
   
    IF NOT AVAIL wm-etiqueta THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="26507"
            &ErrorType="EMS"
            &ErrorParameters="''"}
        
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaRessup DBOProgram 
PROCEDURE validaEtiquetaRessup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pid-etiqueta     LIKE wm-etiqueta.id-etiqueta NO-UNDO.
DEF OUTPUT PARAM pqtd-item        LIKE wm-etiqueta.qtd-item    NO-UNDO.
DEF OUTPUT PARAM p-pede-etiqueta  AS LOG                       NO-UNDO.

FIND FIRST wm-etiqueta WHERE
    wm-etiqueta.id-etiqueta = pid-etiqueta NO-LOCK NO-ERROR.
IF AVAIL wm-etiqueta THEN DO:
    ASSIGN pqtd-item       = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado
           p-pede-etiqueta = IF wm-etiqueta.ind-sit-agrupador = 1 THEN YES
                             ELSE NO.
END.    
ELSE DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-etiqueta-31 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Etiqueta" *}
    ASSIGN c-lbl-liter-etiqueta-31 = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
        &ErrorNumber="56"
        &ErrorType="EMS"
        &ErrorParameters="c-lbl-liter-etiqueta-31"}
    RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEtiquetaSemCarga DBOProgram 
PROCEDURE validaEtiquetaSemCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-id-docto    LIKE wm-docto.id-docto       NO-UNDO.
    DEF INPUT  PARAM p-id-etiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    DEF VAR i-id-carga  LIKE wm-carga.id-carga NO-UNDO.
    
    FIND FIRST wm-docto 
        WHERE wm-docto.id-docto = p-id-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-7 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento-7 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-documento-7"}
        RETURN "NOK":U.
    END.

    FIND FIRST wm-etiqueta WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-32 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-32 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-32"}
        RETURN "NOK":U.
    END.

/*    RUN getCarga IN THIS-PROCEDURE (INPUT  p-id-docto,
 *                                     OUTPUT i-id-carga).*/

/*    IF i-id-carga = 0 THEN DO:
 *         {method/svc/errors/inserr.i
 *             &ErrorNumber="56"
 *             &ErrorType="EMS"
 *             &ErrorParameters="'Carga'"}
 *         RETURN "NOK":U.
 *     END.*/
    
    FIND FIRST wm-etiqueta WHERE 
        wm-etiqueta.id-etiqueta = p-id-etiqueta NO-LOCK NO-ERROR.
        
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-33 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-33 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-33"}
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdItemEtiquetaPicking DBOProgram 
PROCEDURE validaQtdItemEtiquetaPicking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pLocal           LIKE wm-box-movto.cod-local  NO-UNDO.
    DEF INPUT PARAM pIdEtiqueta      LIKE wm-etiqueta.id-etiqueta NO-UNDO.
    DEF INPUT PARAM pQtdItemRetirado LIKE wm-etiqueta.qtd-item    NO-UNDO.
    DEF INPUT PARAM TABLE FOR ttSerialQtd.  
    
    
    DEF VAR de-qtd-disponivel LIKE wm-etiqueta.qtd-item    NO-UNDO.
    DEF VAR de-qtd-lida       LIKE wm-etiqueta.qtd-item    NO-UNDO.
    
    FIND FIRST wm-etiqueta WHERE
        wm-etiqueta.id-etiqueta = pIdEtiqueta NO-LOCK NO-ERROR.
        
    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-34 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-34 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-34"}
        RETURN "NOK":U.
    END.
    
    
    IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:   /* Agrupador */
        
        FIND FIRST ttSerialQtd WHERE
            ttSerialQtd.id-etiqueta = pIdEtiqueta NO-LOCK NO-ERROR.
        
        IF AVAIL ttSerialQtd THEN DO:
        
        /* Agrupador j† lido */
            {method/svc/errors/inserr.i
                &ErrorNumber="26662"
                &ErrorType="EMS"
                &ErrorParameters="''"}
            RETURN "NOK":U.
        END.
        
        
        IF wm-etiqueta.qtd-item <> pQtdItemRetirado THEN DO:
        
        
        /* o Agrupador deve ser retirado integralmente */
            {method/svc/errors/inserr.i
                &ErrorNumber="26661"
                &ErrorType="EMS"
                &ErrorParameters="''"}
            RETURN "NOK":U.
        
        END.
        
                
    END.
    ELSE DO:
    
        IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO: /* N∆o Agrupador */
        
            FIND FIRST ttSerialQtd WHERE
                ttSerialQtd.id-etiqueta = wm-etiqueta.id-agrupador NO-LOCK NO-ERROR.
            
            IF AVAIL ttSerialQtd THEN DO:
                /* Serial pertence a um agrupador j† lido */
                {method/svc/errors/inserr.i
                    &ErrorNumber="26660"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.
            
        ASSIGN de-qtd-disponivel = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.
        
        IF de-qtd-disponivel < pQtdItemRetirado THEN DO:
            /* Etiqueta sem saldo dispon°vel */
            {method/svc/errors/inserr.i
                &ErrorNumber="26658"
                &ErrorType="EMS"
                &ErrorParameters="''"}
            RETURN "NOK":U.
        
        END.
                
        assign l-log-efetua-packing = no.
        &if {&bf_wms_alocacao_logica} &then
            find first wms-item-estab-local no-lock
                 where wms-item-estab-local.cod-estab = wm-etiqueta.cod-estabel
                   and wms-item-estab-local.cod-local = pLocal
                   and wms-item-estab-local.cod-item  = wm-etiqueta.cod-item no-error.
            if not avail wms-item-estab-local then do:
                find first wm-item no-lock
                     where wm-item.cod-item = wm-etiqueta.cod-item no-error.
                if avail wm-item then
                    assign l-log-efetua-packing = wm-item.log-efetua-packing.
            end.
            else
                assign l-log-efetua-packing = wms-item-estab-local.log-efetua-packing.
        &else
            find first wm-item no-lock
                 where wm-item.cod-item = wm-etiqueta.cod-item no-error.
            if avail wm-item then
                assign l-log-efetua-packing = wm-item.log-efetua-packing.
        &endif

        /* aaa */
        IF l-log-efetua-packing = YES THEN DO:
            ASSIGN de-qtd-lida = 0.
        
            FOR EACH ttSerialQtd 
               WHERE ttSerialQtd.id-etiqueta = wm-etiqueta.id-etiqueta:
                ASSIGN de-qtd-lida = de-qtd-lida + ttSerialQtd.qtd-item-retirado.
            END.
            
            ASSIGN de-qtd-disponivel = de-qtd-disponivel - de-qtd-lida.
                
            IF de-qtd-disponivel < pQtdItemRetirado THEN DO:
                /* Etiqueta sem saldo dispon°vel */
                {method/svc/errors/inserr.i
                    &ErrorNumber="26658"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.
    END.
    
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFormarCarga DBOProgram 
PROCEDURE validateFormarCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pIdCarga    LIKE wm-carga.id-carga       NO-UNDO.
    DEFINE INPUT PARAMETER pIdEtiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    FIND FIRST b-wm-etiqueta 
         WHERE b-wm-etiqueta.id-etiqueta = pIdEtiqueta NO-LOCK NO-ERROR.

    IF AVAIL b-wm-etiqueta THEN DO:

        IF b-wm-etiqueta.ind-sit-agrupador = 2 THEN DO:
            FIND FIRST bf{&TableName}
                 WHERE bf{&tablename}.id-agrupador = b-wm-etiqueta.id-etiqueta AND 
                       bf{&tablename}.id-carga    <> 0                         AND
                       bf{&tablename}.id-carga    <> pIdCarga                  NO-LOCK NO-ERROR.

            IF AVAIL bf{&TableName} THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="28408"
                    &ErrorType="EMS"
                    &ErrorParameters="STRING(bf{&TableName}.id-etiqueta) + '~~~~' + STRING(bf{&tablename}.id-carga) + '~~~~' + STRING(b-wm-etiqueta.id-etiqueta)"}
                RETURN "NOK":U.
            END.
        END.

    END.
    ELSE DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-etiqueta-35 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Etiqueta" *}
        ASSIGN c-lbl-liter-etiqueta-35 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-etiqueta-35 + ' ' + STRING(pIdEtiqueta)"}       
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN 
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    FIND FIRST wm-etiqueta WHERE wm-etiqueta.cod-serial = RowObject.cod-serial NO-LOCK NO-ERROR.
    IF AVAIL wm-etiqueta 
    OR RowObject.cod-serial = "0":U 
    OR RowObject.cod-serial = "":U  THEN DO:
        ASSIGN RowObject.cod-serial = STRING(RowObject.id-etiqueta).
    END.

    IF pType = "Create":U OR pType = "Update":U THEN DO:
    
        FIND FIRST wm-embalagem
             WHERE wm-embalagem.cod-embalagem = RowObject.cod-embalagem NO-LOCK NO-ERROR.
        IF NOT AVAIL wm-embalagem THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embalagem-9 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embalagem" *}
            ASSIGN c-lbl-liter-embalagem-9 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-embalagem-9"}        
        END.

        IF NOT CAN-FIND(FIRST Wm-cliente 
        WHERE wm-cliente.cod-cliente = RowObject.cod-cliente NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-cliente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Cliente" *}
            ASSIGN c-lbl-liter-cliente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-cliente"}
        END.
    
/*        IF RowObject.cod-estabel-ord = "":U THEN
 *             {method/svc/errors/inserr.i
 *                 &ErrorNumber="158"
 *                 &ErrorType="EMS"
 *                 &ErrorParameters="'Estabelecimento da OP'"}*/
        
/*         IF RowObject.nr-ord-prod = 0  THEN              */
/*             {method/svc/errors/inserr.i                 */
/*                 &ErrorNumber="158"                      */
/*                 &ErrorType="EMS"                        */
/*                 &ErrorParameters="'Ordem de Produá∆o'"} */
        
/*        IF RowObject.cod-estabel-pedido = "":U THEN
 *             {method/svc/errors/inserr.i
 *                 &ErrorNumber="158"
 *                 &ErrorType="EMS"
 *                 &ErrorParameters="'Estabelecimento do Pedido'"}
 *         
 *         IF RowObject.nr-pedido = 0 THEN
 *             {method/svc/errors/inserr.i
 *                 &ErrorNumber="158"
 *                 &ErrorType="EMS"
 *                 &ErrorParameters="'Pedido'"}*/
        
        FIND FIRST usuario-scm WHERE
            usuario-scm.usuario = RowObject.cod-usuario NO-LOCK NO-ERROR.
            
        IF NOT AVAIL usuario-scm THEN DO:
            DEFINE VARIABLE c-lbl-liter-usuario-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usu†rio" *}
            ASSIGN c-lbl-liter-usuario-4 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-usuario-4"}
        END. 
        ELSE
            IF NOT usuario-scm.log-utiliza-coletor THEN
                {method/svc/errors/inserr.i
                    &ErrorNumber="26068"
                    &ErrorType="EMS"
                    &ErrorParameters="RowObject.cod-usuario"}

        IF RowObject.qtd-item = ? THEN DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_Item" *}
                ASSIGN c-lbl-liter-quantidade-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="36"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-quantidade-item"}
        END.
                    
        IF RowObject.ind-sit-agrupador <> 2 THEN DO:   /* AGRUPA ETIQUETAS  */
            IF RowObject.qtd-item <= 0 THEN DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-item-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_Item" *}
                ASSIGN c-lbl-liter-quantidade-item-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="36"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-quantidade-item-2"}
            END.
            /* so <> 2 */                               
            IF RowObject.qtd-peso < 0 THEN DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-peso AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_Peso" *}
                ASSIGN c-lbl-liter-quantidade-peso = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="6385"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-quantidade-peso"}
            END.
        END.
                
        /* Utilizado Find first devido projeto seguranáa por estabelecimento */
        FIND FIRST Wm-estabel 
             WHERE wm-estabel.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
        IF NOT AVAIL Wm-estabel THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Estabelecimento" *}
            ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-estabelecimento"}
        END.
        
        IF NOT CAN-FIND(FIRST Wm-item WHERE
            wm-item.cod-item = RowObject.cod-item NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-6 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item-6 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-item-6"}
        END.
        
    
        FIND FIRST Wm-item WHERE wm-item.cod-item = RowObject.cod-item NO-LOCK NO-ERROR.
        
        IF AVAIL wm-item THEN DO:
        
            IF wm-item.ind-tipo-contr-est = 3 OR wm-item.ind-tipo-contr-est = 4 THEN DO: /* Controle por lote - deve ser informado */
                IF RowObject.cod-lote = "":U THEN DO:
                    DEFINE VARIABLE c-lbl-liter-nrserie-lote AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Nr.SÇrie_/_Lote" *}
                    ASSIGN c-lbl-liter-nrserie-lote = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17677"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-nrserie-lote"}
                    END. 
                IF RowObject.dt-validade-lote = ? THEN DO:
                    DEFINE VARIABLE c-lbl-liter-data-validade AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Validade" *}
                    ASSIGN c-lbl-liter-data-validade = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17677"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-data-validade"}
                END. 
            END.

            IF wm-item.ind-tipo-contr-est = 2 AND RowObject.cod-lote = "":U THEN DO: /* Controle por N£mero de sÇrie. O campo Nr. SÇrie / lote deve ser informado.*/
                DEFINE VARIABLE c-lbl-liter-nrserie-lote-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nr.SÇrie_/_Lote" *}
                ASSIGN c-lbl-liter-nrserie-lote-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="17677"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-nrserie-lote-2"}
            END.

            IF wm-item.ind-tipo-contr-est = 4 THEN  DO: /* Controla referància - deve ser informada e validada */            
                FIND FIRST Wm-ref-item WHERE 
                    Wm-ref-item.cod-refer = RowObject.cod-refer AND
                    Wm-ref-item.cod-item  = RowObject.cod-item 
                    NO-LOCK NO-ERROR.
                        
                IF NOT AVAIL wm-ref-item THEN DO:
                    DEFINE VARIABLE c-lbl-liter-referencia-5 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Referància" *}
                    ASSIGN c-lbl-liter-referencia-5 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-item-7 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Item" *}
                    ASSIGN c-lbl-liter-item-7 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-referenciaitem AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-referenciaitem = c-lbl-liter-referencia-5 + "~~" + c-lbl-liter-item-7.
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26007"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-merge-referenciaitem"}
                END.
            END.
                
            IF RowObject.ind-sit-agrupador <> 2  /* AGRUPA ETIQUETAS  */
            AND wm-item.ind-tipo-contr =  2
            AND RowObject.qtd-item     <> 1 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="17547"
                        &ErrorType="EMS"
                        &ErrorParameters="wm-item.cod-item"}
            END.
        END.

        /* Validaá∆o ref. a FO 996.443 */
        /* Verifica se a embalagem esta relacionada com a etiqueta e se a mesma possui capacidade suficiente para a qtde informada */
        /* Utilizado Find first devido projeto seguranáa por estabelecimento */
        FIND FIRST wm-item-embalagem-local
             WHERE wm-item-embalagem-local.cod-estabel   = RowObject.cod-estabel
               AND wm-item-embalagem-local.cod-item      = RowObject.cod-item
               AND wm-item-embalagem-local.cod-embalagem = RowObject.cod-embalagem
               AND wm-item-embalagem-local.qtd-item-emb >= RowObject.qtd-item NO-LOCK NO-ERROR.
        IF NOT AVAIL wm-item-embalagem-local THEN DO:
            FIND FIRST wm-item-embalagem-local
                 WHERE wm-item-embalagem-local.cod-estabel   = RowObject.cod-estabel
                   AND wm-item-embalagem-local.cod-item      = RowObject.cod-item
                   AND wm-item-embalagem-local.cod-emb-item  = RowObject.cod-embalagem
                   AND wm-item-embalagem-local.qtd-emb-item >= RowObject.qtd-item NO-LOCK NO-ERROR.
            IF NOT AVAIL wm-item-embalagem-local THEN DO: /* Quantidade da embalagem do item */
                DEFINE VARIABLE c-lbl-liter-embalagem-10 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Embalagem" *}
                ASSIGN c-lbl-liter-embalagem-10 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="158"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-liter-embalagem-10 "}
            END.
        END.

        &IF '{&mgscm_version}' >= '2.07' &THEN
            IF  RowObject.dat-ult-contag > TODAY THEN DO:
                DEFINE VARIABLE c-lbl-liter-data-ultima-contagem AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_Èltima_Contagem" *}
                ASSIGN c-lbl-liter-data-ultima-contagem = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="255"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-data-ultima-contagem"}
            END. 
        &else
            IF  RowObject.data-1 > TODAY THEN DO:
                DEFINE VARIABLE c-lbl-liter-data-ultima-contagem-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_Èltima_Contagem" *}
                ASSIGN c-lbl-liter-data-ultima-contagem-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="255"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-data-ultima-contagem-2"}
            END. 
        &ENDIF
    END.
        

    IF pType = "Delete":U THEN DO:

        /* Etiqueta j† vinculada a uma carga */
        IF RowObject.id-carga <> 0 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26565"
                &ErrorType="EMS"
                &ErrorParameters="''"}
        END.
        
        /* Etiqueta j† vinculada a um agrupador */
        IF RowObject.id-agrupador <> 0 AND RowObject.ind-sit-agrupador = 1 /* N∆o agrupador */ THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="26563"
                &ErrorType="EMS"
                &ErrorParameters="''"}
        END.
        
        /* Etiqueta Agrupadora com itens vinculados a ela */
        IF RowObject.ind-sit-agrupador = 2 /* Agrupador */ THEN DO:
            FIND FIRST bf{&TableName} WHERE bf{&tablename}.id-agrupador = RowObject.id-etiqueta NO-LOCK NO-ERROR.
            IF AVAIL bf{&TableName} THEN 
                {method/svc/errors/inserr.i
                    &ErrorNumber="26564"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
        END.
        
    END.
    /*--- Verifica ocorrància de erros ---*/        
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifyEtiquetas DBOProgram 
PROCEDURE verifyEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-id-etiqueta  like wm-etiqueta.id-etiqueta no-undo.

if not can-find(first wm-etiqueta where
   wm-etiqueta.id-agrupador = p-id-etiqueta no-lock) then do.

    RETURN "NOK":U.

end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GeraEtiqueta_Impressao DBOProgram 
PROCEDURE GeraEtiqueta_Impressao :
/*------------------------------------------------------------------------------
  Purpose:     Faz a gera√ß√£o da etiqueta de endere√ßo tr√¢nsito e imprime caso o
               par√¢metro "Imprime Etiqueta Consolidado (WM0240) esteja marcado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pid-etiqueta-orig LIKE wm-etiqueta.id-etiqueta   NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttwm-box-saldo-aux.
    DEFINE INPUT  PARAMETER pcod-refer   like wm-box-movto.cod-refer         NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-lote    like wm-box-movto.cod-lote          NO-UNDO.    
    DEFINE OUTPUT PARAMETER pid-etiqueta LIKE wm-etiqueta.id-etiqueta        NO-UNDO.

    DEFINE VARIABLE qtd-peso AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-peso   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-impr-etiq AS LOGICAL  NO-UNDO.

    IF NOT VALID-HANDLE(hDBOsc047) THEN
        RUN scbo/bosc047.p PERSISTENT SET hDBOsc047.
    
    IF NOT VALID-HANDLE(hDBOsc044) THEN
        RUN scbo/bosc044.p PERSISTENT SET hDBOsc044.

    IF NOT VALID-HANDLE(hDBOsc058) THEN
        RUN scbo/bosc058.p PERSISTENT SET hDBOsc058.

    bloco:
    DO TRANS:

        FIND FIRST ttwm-box-saldo-aux NO-ERROR.

        RUN openQueryStatic IN hDBOsc044 (INPUT "Main":U).
        RUN goToKey IN hDBOsc044 (INPUT ttwm-box-saldo-aux.cod-item).    
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getDecField IN hDBOsc044 (INPUT "qtd-peso",
                                          OUTPUT d-peso).
        END.

        EMPTY TEMP-TABLE ttWm-etiqueta-aux.
        
        FIND FIRST Wm-etiqueta NO-LOCK
            WHERE Wm-etiqueta.id-etiqueta  = pid-etiqueta-orig NO-ERROR.
                                                         
        FOR EACH  wm-item-embalagem-local
            WHERE wm-item-embalagem-local.cod-estabel   = ttwm-box-saldo-aux.cod-estabel AND
                  wm-item-embalagem-local.cod-local     = ttwm-box-saldo-aux.cod-local   AND
                  wm-item-embalagem-local.cod-item      = ttwm-box-saldo-aux.cod-item    AND
                  wm-item-embalagem-local.cod-embalagem = ttwm-box-saldo-aux.cod-embalagem   NO-LOCK:
            FIND FIRST wm-item-embalagem-etiq
                 WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item      AND
                       wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-embalagem NO-LOCK NO-ERROR.
            IF AVAIL wm-item-embalagem-etiq THEN DO:
                FIND FIRST wm-item-embalagem-etiq
                     WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item     AND
                           wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-emb-item NO-LOCK NO-ERROR.                

                IF AVAIL wm-item-embalagem-etiq THEN DO:                    
                    CREATE ttWm-etiqueta-aux.
                    ASSIGN ttWm-etiqueta-aux.cod-estabel        = ttwm-box-saldo-aux.cod-estabel
                           ttWm-etiqueta-aux.cod-item           = ttwm-box-saldo-aux.cod-item
                           ttWm-etiqueta-aux.cod-refer          = pcod-refer
                           ttWm-etiqueta-aux.cod-embalagem      = Wm-etiqueta.cod-embalagem
                           ttWm-etiqueta-aux.cod-lote           = pcod-lote
                           ttWm-etiqueta-aux.dt-validade-lote   = ?
                           ttWm-etiqueta-aux.cod-cliente        = ttwm-box-saldo-aux.cod-cliente
                           ttWm-etiqueta-aux.cod-estabel-ord    = ""
                           ttWm-etiqueta-aux.cod-estabel-pedido = ""
                           ttWm-etiqueta-aux.qtd-peso           = d-peso * ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.qtd-item           = ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.nr-ord-prod        = 1
                           ttWm-etiqueta-aux.nr-pedido          = 0
                           ttWm-etiqueta-aux.nr-pedcli          = ""
                           ttWm-etiqueta-aux.nome-abrev         = ""
                           ttWm-etiqueta-aux.qtd-item-retirado  = ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.cod-usuario        = c-seg-usuario
                           ttWm-etiqueta-aux.ind-sit-agrupador  = if wm-item-embalagem-local.cod-emb-item <> "" then 1 else 3
                           ttWm-etiqueta-aux.log-reportada      = YES.
                END.
                ELSE DO:                    
                    CREATE ttWm-etiqueta-aux.
                    ASSIGN ttWm-etiqueta-aux.cod-estabel        = ttwm-box-saldo-aux.cod-estabel
                           ttWm-etiqueta-aux.cod-item           = ttwm-box-saldo-aux.cod-item
                           ttWm-etiqueta-aux.cod-refer          = pcod-refer
                           ttWm-etiqueta-aux.cod-embalagem      = Wm-etiqueta.cod-embalagem
                           ttWm-etiqueta-aux.cod-lote           = pcod-lote
                           ttWm-etiqueta-aux.dt-validade-lote   = ?
                           ttWm-etiqueta-aux.cod-cliente        = ttwm-box-saldo-aux.cod-cliente
                           ttWm-etiqueta-aux.cod-estabel-ord    = ""
                           ttWm-etiqueta-aux.cod-estabel-pedido = ""
                           ttWm-etiqueta-aux.qtd-peso           = d-peso * ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.qtd-item           = ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.nr-ord-prod        = 1
                           ttWm-etiqueta-aux.nr-pedido          = 0
                           ttWm-etiqueta-aux.nr-pedcli          = ""
                           ttWm-etiqueta-aux.nome-abrev         = ""
                           ttWm-etiqueta-aux.qtd-item-retirado  = ttwm-box-saldo-aux.qtd-item
                           ttWm-etiqueta-aux.cod-usuario        = c-seg-usuario
                           ttWm-etiqueta-aux.ind-sit-agrupador  = if wm-item-embalagem-local.cod-emb-item <> "" then 1 else 3
                           ttWm-etiqueta-aux.log-reportada      = YES.    
                END.
            END.
        END.
        IF  NOT VALID-HANDLE(hDBOsc058) THEN
            RUN scbo/bosc058.p PERSISTENT SET hDBOsc058.

        RUN retornaDtValidade IN hDBOsc058 (INPUT ttwm-box-saldo-aux.cod-estabel,
                                            INPUT ttwm-box-saldo-aux.cod-local,
                                            INPUT ttwm-box-saldo-aux.cod-item,
                                            INPUT ttwm-box-saldo-aux.cod-refer,
                                            INPUT ttwm-box-saldo-aux.cod-lote,
                                            OUTPUT ttWm-etiqueta-aux.dt-validade-lote).        
        
        RUN geraEtiquetas IN THIS-PROCEDURE (INPUT TABLE ttWm-etiqueta-aux,
                                             INPUT 1,
                                             OUTPUT TABLE ttSerial).

        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE RowErrors).

            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                    run piDestroiHandle.
                    UNDO bloco, RETURN "NOK":U.
                end.

            
        END.
        ELSE DO:
            FIND FIRST ttSerial NO-LOCK NO-ERROR.
            IF  AVAIL ttSerial THEN DO:    
                /* gera etiqueta com quantidade retirada igual ao total da etiqueta 
                   para que a confirmacao de entrada da transferencia reduza da quantidade
                   retirada o quanto foi armazenado. Desta forma, a nova etiqueta
                   eh tratada da mesma maneira que uma etiqueta que foi retirada totalmente
                   pela saida da transferencia */
         
                IF  NOT CAN-FIND (FIRST tt-etiqueta-wms
                                  WHERE tt-etiqueta-wms.id-etiqueta = ttSerial.de-serial NO-LOCK) THEN DO:
                    CREATE tt-etiqueta-wms.
                    ASSIGN tt-etiqueta-wms.id-etiqueta   = ttSerial.de-serial
                           tt-etiqueta-wms.cod-embalagem = "":U
                           tt-etiqueta-wms.cod-layout    = 0.
                END.
    
                RUN openQueryStatic IN hDBOsc047 (INPUT "Main":U).
                RUN goToKey IN hDBOsc047 (INPUT ttwm-box-saldo-aux.cod-estabel, ttwm-box-saldo-aux.cod-local).    

                IF  RETURN-VALUE = "OK":U THEN DO:
                    RUN getLogField IN hDBOsc047 (INPUT "log-impr-etiq",
                                                  OUTPUT l-impr-etiq).
                END.

                IF l-impr-etiq THEN DO:                                            
                    /* Chamada API Impressao - Data Collection */
                    RUN bcp/bcapi9026.p (INPUT  TABLE tt-etiqueta-wms,
                                         OUTPUT TABLE tt-erro).
            
                    IF  CAN-FIND (FIRST tt-erro) THEN DO:
                        /* Logica para mostrar os erros (tt-erro) ao usuario */
                        FOR EACH tt-erro NO-LOCK:
                            RUN piCreateError IN THIS-PROCEDURE (INPUT 17567,
                                                                 INPUT STRING(tt-erro.mensagem),
                                                                 INPUT "EMS",
                                                                 INPUT "ERROR").
                        END.
            
                        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                             run piDestroiHandle.
                             UNDO bloco, RETURN "NOK":U.
                           end.
                    END.
                END.


                IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
                    RUN goToKey IN THIS-PROCEDURE (INPUT ttSerial.de-serial).

                    IF RETURN-VALUE = "OK":U THEN DO:
                        /* Atualizar situacao Etiqueta para Impressa */
                        FOR LAST tt-etiqueta-wms:                            
                            FIND FIRST Wm-etiqueta EXCLUSIVE-LOCK
                                 WHERE Wm-etiqueta.id-etiqueta  = tt-etiqueta-wms.id-etiqueta NO-ERROR.
                                             
                            IF  AVAIL Wm-etiqueta THEN DO:
                                IF  Wm-etiqueta.log-impressa THEN NEXT.

                              /*  ASSIGN  wm-etiqueta.cdd-etiq-origin = pid-etiqueta-orig.*/

                                 IF l-impr-etiq THEN 
                                     ASSIGN wm-etiqueta.log-impressa = YES.                                                                        

                                RUN emptyRowErrors IN THIS-PROCEDURE.
                                RUN emptyRowObject IN THIS-PROCEDURE.
                                RUN goToKey        IN THIS-PROCEDURE (INPUT tt-etiqueta-wms.id-etiqueta).
                                RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE RowObject).
                                RUN updateRecord   IN THIS-PROCEDURE.
                                RUN getRowErrors   IN THIS-PROCEDURE (OUTPUT TABLE RowErrors).
            
                                IF  CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                                    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                                            run piDestroiHandle.
                                            UNDO bloco, RETURN "NOK":U.
                                        end.
                                END.
                            END.
                            ELSE DO:
                                IF NOT AVAIL wm-etiqueta THEN DO:
                                    /* Inicio -- Projeto Internacional */
                                    DEFINE VARIABLE c-lbl-liter-etiqueta-17 AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "Etiqueta" *}
                                    ASSIGN c-lbl-liter-etiqueta-17 = TRIM(RETURN-VALUE).
                                    {method/svc/errors/inserr.i
                                        &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-etiqueta-17"}
                                    run piDestroiHandle.
                                    RETURN "NOK".
                                END.       

                            END.
                            
                        END.
                    END.
                END.
                ASSIGN pid-etiqueta  = ttSerial.de-serial.
            END.
            
        END.
    END.
    
    run piDestroiHandle.

    RETURN "OK":U.

END PROCEDURE.

procedure Gera_tt_Etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-local      AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER p-cod-item       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-refer      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-lote       AS CHARACTER NO-UNDO.              
    DEFINE INPUT PARAMETER p-qtd-item       AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER pIdDocto         LIKE wms-docto-item-agru.id-docto NO-UNDO.
    DEFINE INPUT PARAMETER piCodEmbalagem   like wm-etiqueta.cod-embalagem NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-etiqueta.   
        
    DEFINE VARIABLE de-saldo-item AS DECIMAL NO-UNDO.  
    DEFINE VARIABLE de-id-docto-agrup LIKE wms-docto-item-agru.id-docto NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo-box AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qtde-atendida AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cCodEmbalagemPai like wm-etiqueta.cod-embalagem NO-UNDO.         
    
    ASSIGN de-saldo-item = p-qtd-item.
        
    Empty temp-table tt-etiqueta.    
    
    /* LOCALIZADO O DOCUMENTO CONSOLIDADO atraves do Docto Origem */            
    FIND FIRST wms-docto-item-agru
                WHERE wms-docto-item-agru.cod-estabel   = p-cod-estabel  
                  AND wms-docto-item-agru.cod-local     = p-cod-local  
                  AND wms-docto-item-agru.id-docto-orig = pIdDocto  NO-LOCK NO-ERROR.
    IF AVAIL wms-docto-item-agru THEN 
        ASSIGN de-id-docto-agrup = wms-docto-item-agru.id-docto.     
                   
    FIND FIRST wms-docto-item-agru
                WHERE wms-docto-item-agru.cod-estabel   = p-cod-estabel 
                  AND wms-docto-item-agru.cod-local     = p-cod-local  
                  AND wms-docto-item-agru.id-docto      = de-id-docto-agrup NO-LOCK NO-ERROR. 
                 
    /* buscar atraves do Docto Consolidado as movimentacoes de entrada no endereco de transito */ 
    IF AVAIL wms-docto-item-agru THEN DO: 
        FOR EACH bfwm-box-movto no-lock
                 WHERE bfwm-box-movto.cod-estabel       = p-cod-estabel 
                   AND bfwm-box-movto.cod-local         = p-cod-local
                   AND bfwm-box-movto.id-docto          = de-id-docto-agrup
                   AND bfwm-box-movto.ind-tipo-movto    = 1
                   AND bfwm-box-movto.cod-item          = p-cod-item 
                   AND bfwm-box-movto.cod-refer         = p-cod-refer
                   AND ( bfwm-box-movto.cod-lote        = p-cod-lote OR bfwm-box-movto.cod-lote  = ''):
               
           /* valida se ja foi atendido a quantidade do movimernto para sair*/
           if p-qtd-item <> de-qtde-atendida then do:
                      
                /* Vamos buscar todas as etiquetas do item/refer/lote que esta no box e que pertence ao documento consolidado */                        
                FOR EACH wm-box-saldo-etiqueta NO-LOCK
                     WHERE wm-box-saldo-etiqueta.cod-estabel = p-cod-estabel
                       AND wm-box-saldo-etiqueta.cod-local   = p-cod-local
                       AND wm-box-saldo-etiqueta.id-box      = bfwm-box-movto.id-box
                       AND wm-box-saldo-etiqueta.id-docto    = de-id-docto-agrup:
                    
                   /* Valida se a Etiqueta selecionada pertence ao item/refer/lote/embalagem */                   
                   /* Validando a Etiqueta: Se a Embalagem da Etiqueta confere com  a Embalagem da Sugest∆o de Armazenamento
                       Deve ser considerado Embalagem Pai e Filha                      */                                        
                    FIND FIRST wm-item-embalagem-local 
                         WHERE wm-item-embalagem-local.cod-estabel   = p-cod-estabel AND
                               wm-item-embalagem-local.cod-local     = p-cod-local   AND
                               wm-item-embalagem-local.cod-embalagem = piCodEmbalagem           AND
                               wm-item-embalagem-local.cod-item      = p-cod-item NO-LOCK NO-ERROR.
                    IF AVAIL wm-item-embalagem-local THEN
                        ASSIGN cCodEmbalagemPai = wm-item-embalagem-local.cod-emb-item.
                      
                   FIND FIRST wm-etiqueta 
                                    WHERE  wm-etiqueta.id-etiqueta      = wm-box-saldo-etiqueta.id-etiqueta
                                      AND  wm-etiqueta.cod-estabel      = p-cod-estabel
                                      AND  wm-etiqueta.cod-item         = p-cod-item 
                                      AND  wm-etiqueta.cod-refer        = p-cod-refer
                                      AND  wm-etiqueta.cod-lote         = p-cod-lote 
                                      AND (wm-etiqueta.cod-embalagem    = piCodEmbalagem or
                                           wm-etiqueta.cod-embalagem    = cCodEmbalagemPai) NO-LOCK NO-ERROR.                                      
                   IF AVAIL wm-etiqueta THEN DO:                                                                          
                        Assign de-qtd-saldo-box = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.                                                                                                             
                                
                        /* quando o saldo da etiqueta e = ao qtde solicitada */
                        if de-saldo-item = de-qtd-saldo-box then do:
                            IF NOT CAN-FIND( FIRST tt-etiqueta 
                                               WHERE tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta NO-LOCK ) THEN DO:
                                create tt-etiqueta.
                                assign tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta
                                       tt-etiqueta.qtd-retirada = de-qtd-saldo-box.
                                assign de-qtde-atendida = p-qtd-item.
                                RETURN "OK":U.
                            END.
                                                             
                        end. /* qtde solicitada > que saldo da etiqueta */
                        else if de-saldo-item > de-qtd-saldo-box then do:
                            IF NOT CAN-FIND( FIRST tt-etiqueta 
                                               WHERE tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta NO-LOCK ) THEN DO:
                            
                                create tt-etiqueta.
                                assign tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta
                                       tt-etiqueta.qtd-retirada = de-qtd-saldo-box.
                                ASSIGN de-saldo-item = de-saldo-item - de-qtd-saldo-box
                                       de-qtde-atendida = de-qtde-atendida + de-saldo-item.
                             
                            END.
                            
                        end.
                        else do: /* Qdte solicitada e menor que o saldo da etiqueta */
                            IF NOT CAN-FIND( FIRST tt-etiqueta 
                                               WHERE tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta NO-LOCK ) THEN DO:
                                                
                                create tt-etiqueta.
                                assign tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta
                                       tt-etiqueta.qtd-retirada = de-saldo-item.
                                assign de-qtde-atendida = p-qtd-item. 
        
                           end.
                           RETURN "OK":U.
                            
                        END.
                   end. /* if etiqueta */                            
                END. /*loop saldo box etiqueta */
           end.
           else
            RETURN "OK":U.
                       
        end. /* loop box movto */
    end.                                               

    RETURN "OK":U.    

END PROCEDURE.
    
      
    
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCreateError DBOProgram 
PROCEDURE piDestroiHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hDBOsc047) THEN
        DELETE PROCEDURE hDBOsc047.
    
    IF VALID-HANDLE(hDBOsc044) THEN
        DELETE PROCEDURE hDBOsc044.

    IF VALID-HANDLE(hDBOsc058) THEN
        DELETE PROCEDURE hDBOsc058.

    assign 
          hDBOsc047 = ?
          hDBOsc044 = ?
          hDBOsc058 = ?.
          
    RETURN "OK":U.    

END PROCEDURE.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCreateError DBOProgram 
PROCEDURE piCreateError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    END.

    RETURN "OK":U.    

END PROCEDURE.


