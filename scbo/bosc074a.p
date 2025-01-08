/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOSC074A 2.00.01.006}  /*** 010106 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOSC074A MUT}
&ENDIF

/*******************************************************************************
**    Programa: bosc074a.p - ImpressÆo de Etiquetas Data Collection
**    Autores : Carlos da Costa Junior
**              Luis Fernando de Matos          
**    Data    : 27/03/2001
**    VersÆo  : 2.00.00.000
*******************************************************************************/
DEF INPUT PARAM pCod-usuario      AS CHAR NO-UNDO.
DEF INPUT PARAM pId-etiqueta-ini  AS DEC  NO-UNDO.
DEF INPUT PARAM pId-etiqueta-fim  AS DEC  NO-UNDO.

/****************************** DEFINI€ÇO DATA COLLECTION ********************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi001.i}   /* Definicao da temp-table tt-trans                       */
{bcp/bcapi002.i}   /* Definicao da temp-table tt-etiqueta                    */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
/*{vpp/vpbc002.i} */    /* Definicao dos campos de comunicacao com o adapter      */
/*****************************************************************************/

Define Variable vNumSerialAgrup As Decimal                  No-undo.
Define Variable vNumSeq         As Integer                  No-undo.
Define Variable vLogOK          As Logical                  No-undo.
Define Variable vTransDetail    As Character                No-undo.
Define Variable c-seg-usuario   As Char     Format  "x(12)" No-undo.
Define Variable wgBOSC074       As Handle                   No-undo.
Define Variable vRaw            As Raw                      No-undo.

for each wm-etiqueta where
    wm-etiqueta.id-etiqueta >= pId-etiqueta-ini AND
    wm-etiqueta.id-etiqueta <= pId-etiqueta-fim EXCLUSIVE-LOCK:


    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bosc074a"
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = pCod-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    /* INDICA QUE NÇO TEM INTEGRACAO COM DATA COLLECTION */
    IF RETURN-VALUE = "NOK" 
    THEN
        RETURN.
    /* INDICA QUE NÇO TEM INTEGRACAO COM DATA COLLECTION */

    Find First tt-prog-bc   No-error.
    FOR EACH tt-erro:
        
        run utp/ut-msgs.p (input "show":U,
                           input tt-erro.cd-erro,
                           input " ":U).
        
    end.
    
    Find First tt-erro      No-error.

    IF AVAIL TT-ERRO
    THEN
        RETURN "NOK".

    Create  tt-etiqueta.
    Assign  tt-etiqueta.cod-versao-integracao = 1
            tt-etiqueta.i-sequen              = 1
            tt-etiqueta.cd-trans              = tt-prog-bc.cd-trans
            tt-etiqueta.it-codigo             = wm-etiqueta.cod-item 
            tt-etiqueta.dt-val-lote           = wm-etiqueta.dt-validade-lote 
            tt-etiqueta.cod-estabel           = wm-etiqueta.cod-estabel 
            tt-etiqueta.lote                  = wm-etiqueta.cod-lote                
            tt-etiqueta.nr-docto              = string(wm-etiqueta.nr-ord-prod)
            tt-etiqueta.quantidade            = wm-etiqueta.qtd-item 
            tt-etiqueta.qt-etiqueta           = 1
            tt-etiqueta.cod-referencia        = wm-etiqueta.cod-refer 
            tt-etiqueta.auxiliar-01           = string(wm-etiqueta.id-etiqueta,'99999999999999')
            tt-etiqueta.peso-bruto            = wm-etiqueta.qtd-peso
            tt-etiqueta.peso-liquido          = wm-etiqueta.qtd-peso.

    FIND FIRST ITEM 
         WHERE ITEM.it-codigo = wm-etiqueta.cod-item 
         NO-LOCK NO-ERROR.

    IF AVAIL ITEM THEN
        ASSIGN tt-etiqueta.auxiliar-02 = ITEM.descricao-1 
               tt-etiqueta.auxiliar-03 = ITEM.descricao-2. 


    Assign vTransDetail = tt-prog-bc.cd-trans                                             +
                          " WMS - " +                   
                          " Ordem: "    + String(wm-etiqueta.nr-ord-prod)   +                     
                          " Usuario: "  + String(wm-etiqueta.cod-usuario) +                  
                          " Data: "     + String(Today,'99/99/9999')                      +                  
                          " Hora: "     + String(time,'hh:mm:ss').

    Raw-transfer tt-etiqueta To vRaw No-error.

    Create  tt-trans.
    Assign  tt-trans.cod-versao-integracao  = 001
            tt-trans.i-sequen               = 1
            tt-trans.cd-trans               = tt-prog-bc.cd-trans
            tt-trans.detalhe                = vTransDetail
            tt-trans.usuario                = pCod-usuario
            tt-trans.conteudo-trans         = vRaw
            tt-trans.atualizada             = no
            tt-trans.etiqueta               = Yes.

    Run bcp/bcapi001.p (input-output table tt-trans,
                        input-output table tt-erro).

    find first tt-erro no-lock no-error.

    FOR EACH TT-ERRO:
        
        run utp/ut-msgs.p (input "show":U,
                           input tt-erro.cd-erro,
                           input " ":U).

    End. /* If  Available tt-erro */

    If  Available tt-erro 
    Then
        Return 'NOK'.

    For Each tt-trans:
        Delete tt-trans.
    End.

    For Each tt-etiqueta:
        Delete tt-etiqueta.
    End.

    ASSIGN wm-etiqueta.log-impressa  = yes
           wm-etiqueta.log-reportada = yes.

End. /* For Each wm-etiqueta */

RELEASE wm-etiqueta.
