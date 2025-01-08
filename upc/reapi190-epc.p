/* ----------------------------------------------------------------------------
   Programa..: upc/reapi190-upc.p
   Data......: Agosto/2009
   Autor.....: Osnir
   Objetivo..: Utilizada pelo esrep028
---------------------------------------------------------------------------- */

{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

/* DefinicÆo da temp-table TT-DOCUM-EST - reapi190.i1*/

def temp-table tt-docum-est no-undo
    field registro              as   int
    field serie-docto           like docum-est.serie-docto 
    field nro-docto             like docum-est.nro-docto 
    field cod-emitente          like docum-est.cod-emitente 
    field nat-operacao          like docum-est.nat-operacao 
    field cod-observa           like docum-est.cod-observa 
    field cod-estabel           like docum-est.cod-estabel 
    field estab-fisc            like docum-est.estab-fisc
    field conta-transit         like docum-est.conta-transit 
    field dt-emissao            like docum-est.dt-emissao 
    field dt-trans              like docum-est.dt-trans 
    field usuario               like docum-est.usuario 
    field uf                    like docum-est.uf 
    field via-transp            like docum-est.via-transp
    field mod-frete             like docum-est.mod-frete 
    field nff                   like docum-est.nff 
    field tot-peso              like docum-est.tot-peso 
    field tot-desconto          like docum-est.tot-desconto 
    field valor-frete           like docum-est.valor-frete 
    field valor-seguro          like docum-est.valor-seguro 
    field valor-embal           like docum-est.valor-embal 
    field valor-outras          like docum-est.valor-outras 
    field valor-mercad          like docum-est.valor-mercad 
    field dt-venc-ipi           like docum-est.dt-venc-ipi 
    field dt-venc-icm           like docum-est.dt-venc-icm 
    field tot-valor             like docum-est.tot-valor
    field efetua-calculo        as   int  format "9"
    field observacao            like docum-est.observacao
    field cotacao-dia           like docum-est.cotacao-dia     /* Campo Integracao Modulo Importacao */
    field embarque              as character format "x(12)"    /* Campo Integracao Modulo Importacao */

    field sequencia             as   int  format "999999"
    field esp-docto             like docum-est.esp-docto   
    field rec-fisico            like docum-est.rec-fisico   /* atribui‡Æo direta = no       */
    field origem                like docum-est.origem       /* atribui‡Æo direta = "I"      */
    field pais-origem           like docum-est.pais-origem  /* atribui‡Æo direta = "RE1001" */
    field ct-transit            like conta-contab.ct-codigo /* pegar conta-contab.ct-codigo */    
    field sc-transit            like conta-contab.sc-codigo /* pegar conta-contab.sc-codigo */  
    field gera-unid-neg         as   int format "9"  /* 0-NÆo; 1-Gera */
    FIELD nome-transp           AS CHAR FORMAT "x(12)"
    FIELD cod-placa-1           AS CHAR FORMAT "x(07)"
    FIELD cod-placa-2           AS CHAR FORMAT "x(07)"
    FIELD cod-placa-3           AS CHAR FORMAT "x(07)"
    FIELD cod-uf-placa-1        AS CHAR FORMAT "x(02)"
    FIELD cod-uf-placa-2        AS CHAR FORMAT "x(02)"
    FIELD cod-uf-placa-3        AS CHAR FORMAT "x(02)"
    field char-1                like docum-est.char-1
    index documento is primary unique
          serie-docto
       nro-docto
       cod-emitente
       nat-operacao

    index seq is unique
          sequencia.

DEF VAR rw-docum-est AS ROWID NO-UNDO.
DEF VAR hShowMsg    AS HANDLE NO-UNDO.

/* main block */
case p-ind-event:
/*     WHEN "fim-reapi190" THEN DO:                                                                                                            */
/*         FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event NO-ERROR.                                                                    */
/*         IF AVAIL tt-epc THEN DO:                                                                                                            */
/*             ASSIGN rw-docum-est = TO-ROWID(tt-epc.val-parameter).                                                                           */
/*                                                                                                                                             */
/*             FIND FIRST docum-est                                                                                                            */
/*                  WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.                                                                    */
/*             IF NOT AVAIL docum-est THEN                                                                                                     */
/*                 RETURN "OK":U.                                                                                                              */
/*                                                                                                                                             */
/*             FIND ser-estab WHERE                                                                                                            */
/*                  ser-estab.cod-estabel = docum-est.cod-estabel AND                                                                          */
/*                  ser-estab.serie       = docum-est.serie-docto NO-LOCK NO-ERROR.                                                            */
/*             IF AVAIL ser-estab                                                                                                              */
/*                  AND ser-estab.log-2 = NO THEN DO:                                                                                          */
/*                 CREATE RowErrors.                                                                                                           */
/*                 ASSIGN RowErrors.ErrorSequence    = 1                                                                                       */
/*                        RowErrors.ErrorNumber      = 17567                                                                                   */
/*                        RowErrors.ErrorDescription = "S‚rie incorreta!"                                                                      */
/*                        RowErrors.ErrorType        = "WARNING"                                                                               */
/*                        RowErrors.ErrorHelp        = "Verifique no ft0114 a s‚rie marcada como Gera Faturamento para este estabelecimento.". */
/*                                                                                                                                             */
/*                 IF NOT VALID-HANDLE(hShowMsg) or                                                                                            */
/*                    hShowMsg:TYPE <> "PROCEDURE":U or                                                                                        */
/*                    hShowMsg:FILE-NAME <> "utp/ShowMessage.w":U THEN                                                                         */
/*                         RUN utp/ShowMessage.w PERSISTENT SET hShowMsg.                                                                      */
/*                                                                                                                                             */
/*                 RUN setModal IN hShowMsg (INPUT YES) NO-ERROR.                                                                              */
/*                 RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).                                                                       */
/*             END.                                                                                                                            */
/*         END.                                                                                                                                */
/*     END.                                                                                                                                    */
    WHEN "validateDocumEst" THEN DO:
        FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event NO-ERROR.
        IF NOT AVAIL tt-epc THEN RETURN "OK".
        
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "validateDocumEst"
               tt-epc.cod-parameter = "validateDocumEst"
               tt-epc.val-parameter = "no".
    END.

    WHEN "fim-reapi190" THEN DO:                                                                                                            
        FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event NO-ERROR.                                                                   
        IF AVAIL tt-epc THEN DO:                                                                                                           
            ASSIGN rw-docum-est = TO-ROWID(tt-epc.val-parameter). 

            FIND FIRST docum-est                                                                                                           
                WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.                                                                   
            IF NOT AVAIL docum-est THEN                                                                                                    
                RETURN "OK":U.      
            
            FOR FIRST int-mod-transp-importacao NO-LOCK
                WHERE int-mod-transp-importacao.cod-estabel  = docum-est.cod-estabel
                  AND int-mod-transp-importacao.serie-docto  = docum-est.serie-docto
                  AND int-mod-transp-importacao.nat-operacao = docum-est.nat-operacao:

                ASSIGN  docum-est.nome-transp           = int-mod-transp-importacao.nome-transp.
                
                ASSIGN OVERLAY(docum-est.char-2,143,8)  = STRING(int-mod-transp-importacao.cod-modalid-frete).
            END.
                RELEASE int-mod-transp-importacao.
        END.
        RELEASE docum-est.
    END.
end case.
