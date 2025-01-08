/***********************************************************************
**  Programa..: upc\re1001a-upc.p
**  Autor.....: Anderson Hoepers
**  Data......: 17/12/2012 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 17/12/2002
**                  Desenvolvimento Programa
************************************************************************/
/*
{utp/ut-glob.i}
*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario              AS CHAR          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza-re1001a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-obs-re1001a             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fornecedor-re1001a      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-re1001a           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nro-docto-re1001a       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-re1001a     AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-re1001a-upc              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-uf-re1001a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-data-re1001a      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-cgc-re1001a       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-modelo-re1001a    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-serie-re1001a     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-nro-docto-re1001a AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-nr-nfe-re1001a    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-chave-digito-re1001a    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-trans-re1001a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-emissao-re1001a      AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-chave-acesso-re1001a LIKE docum-est.cod-chave-aces-nf-eletro NO-UNDO.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE BUFFER bf-docum-est FOR docum-est.

IF  p-ind-event  = "AFTER-INITIALIZE" AND 
    p-ind-object = "CONTAINER" THEN DO:

    RUN upc/re1001a-upc.p PERSISTENT SET h-re1001a-upc (INPUT "",            
                                                        INPUT "",            
                                                        INPUT p-wgh-object,  
                                                        INPUT p-wgh-frame,   
                                                        INPUT "",            
                                                        INPUT p-row-table).  

    ASSIGN h-object = p-wgh-frame.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:

            CASE h-object:NAME:
                WHEN 'nat-operacao':U      THEN ASSIGN wh-natureza-re1001a        = h-object.
                WHEN 'cb-cod-observa':U    THEN ASSIGN wh-obs-re1001a             = h-object.
                WHEN 'cod-emitente':U      THEN ASSIGN wh-fornecedor-re1001a      = h-object.
                WHEN 'serie-docto':U       THEN ASSIGN wh-serie-re1001a           = h-object.
                WHEN 'i-nro-docto':U       THEN ASSIGN wh-nro-docto-re1001a       = h-object.
                WHEN 'i-chave-uf':U        THEN ASSIGN wh-chave-uf-re1001a        = h-object.
                WHEN 'c-chave-data':U      THEN ASSIGN wh-chave-data-re1001a      = h-object.
                WHEN 'c-chave-cgc':U       THEN ASSIGN wh-chave-cgc-re1001a       = h-object.
                WHEN 'c-chave-modelo':U    THEN ASSIGN wh-chave-modelo-re1001a    = h-object.
                WHEN 'c-chave-serie':U     THEN ASSIGN wh-chave-serie-re1001a     = h-object.
                WHEN 'i-chave-nro-docto':U THEN ASSIGN wh-chave-nro-docto-re1001a = h-object.
                WHEN 'i-chave-nr-nfe':U    THEN ASSIGN wh-chave-nr-nfe-re1001a    = h-object.
                WHEN 'i-chave-digito':U    THEN ASSIGN wh-chave-digito-re1001a    = h-object.
                WHEN 'cod-estabel':U       THEN ASSIGN wh-cod-estabel-re1001a     = h-object:HANDLE.
                WHEN 'dt-trans':U          THEN ASSIGN wh-dt-trans-re1001a        = h-object.
                WHEN 'dt-emissao':U        THEN ASSIGN wh-dt-emissao-re1001a      = h-object.

            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE 
            ASSIGN h-object = h-object:FIRST-CHILD NO-ERROR.
    END.

    ASSIGN wh-obs-re1001a:SENSITIVE = NO.

    IF VALID-HANDLE(wh-natureza-re1001a) THEN
        ON "LEAVE":U OF wh-natureza-re1001a PERSISTENT RUN pi-leave-natureza IN h-re1001a-upc.

    /*Chamado: 23334 - Sugerir Estabelecimento do usuario*/
    
    IF VALID-HANDLE(wh-cod-estabel-re1001a) THEN DO:
        FIND FIRST usuar_univ NO-LOCK 
           WHERE usuar_univ.cod_usuario = c-seg-usuario NO-ERROR.
          
        IF AVAIL usuar_univ THEN 
           ASSIGN wh-cod-estabel-re1001a:SCREEN-VALUE = usuar_univ.cod_estab.    
    END.
END.

IF  p-ind-event  = "BEFORE-ASSIGN" AND 
    p-ind-object = "CONTAINER" THEN DO:
    FIND natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = wh-natureza-re1001a:SCREEN-VALUE NO-ERROR.

    IF  AVAIL natur-oper THEN DO:
    
        IF  natur-oper.imp-nota
        AND wh-dt-trans-re1001a:SCREEN-VALUE <> wh-dt-emissao-re1001a:SCREEN-VALUE THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 17006,
                   INPUT "PROCEDIMENTO INTERROMPIDO: Datas diferem.~~Para esta natureza de operaá∆o as datas de emiss∆o e transaá∆o devem ser iguais.").
            RETURN ERROR.
        END. /* IF  natur-oper.imp-nota ... */
            
        IF  natur-oper.cd-situacao = 99 /* Serviáos */ 
        AND wh-obs-re1001a:SCREEN-VALUE <> "Serviáos" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Observaá∆o inv†lida.~~Esta natureza de operaá∆o possui o Modelo Doc OF igual a 99, o qual, exige que a observaá∆o seja do tipo Serviáos.").
            RETURN ERROR.
        END. /* IF  natur-oper.cd-situacao */

    END. /* IF  AVAIL natur-oper THEN DO: */

    IF  wh-chave-uf-re1001a:SENSITIVE = TRUE 
    THEN ASSIGN c-chave-acesso-re1001a = trim(string(wh-chave-uf-re1001a:SCREEN-VALUE,"99")               + 
                                              string(wh-chave-data-re1001a:SCREEN-VALUE)                  + 
                                              string(wh-chave-cgc-re1001a:SCREEN-VALUE)                   +
                                              string(wh-chave-modelo-re1001a:SCREEN-VALUE)                + 
                                              string(wh-chave-serie-re1001a:SCREEN-VALUE)                 + 
                                              string(wh-chave-nro-docto-re1001a:SCREEN-VALUE,"999999999") +
                                              string(wh-chave-nr-nfe-re1001a:SCREEN-VALUE,"999999999")    + 
                                              string(wh-chave-digito-re1001a:SCREEN-VALUE)).
    ELSE ASSIGN c-chave-acesso-re1001a = "".
        
    IF  wh-chave-uf-re1001a:SENSITIVE = TRUE THEN DO:
        FIND FIRST emitente NO-LOCK WHERE  emitente.cgc = wh-chave-cgc-re1001a:SCREEN-VALUE NO-ERROR.

        FIND FIRST bf-docum-est NO-LOCK
            WHERE  bf-docum-est.serie-docto   = string(wh-chave-serie-re1001a:SCREEN-VALUE)
            AND    bf-docum-est.nro-docto     = string(wh-chave-nro-docto-re1001a:SCREEN-VALUE)
            AND    bf-docum-est.cod-emitente  = emitente.cod-emitente 
            AND    bf-docum-est.nat-operacao <> wh-natureza-re1001a:SCREEN-VALUE NO-ERROR.
        IF  AVAIL  bf-docum-est THEN DO:

            IF  bf-docum-est.cod-chave-aces-nf-eletro = c-chave-acesso-re1001a THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 27100, INPUT "Procedimento interrompido." + "~~" + 
                                                                      "Documento j† registrado com mesma chave de acesso em " + trim(string(bf-docum-est.dt-trans, "99/99/9999":U)) + ", CFOP: " + trim(STRING(bf-docum-est.nat-operacao)) + "." +
                                                                      CHR(10) + "Deseja continuar ?").
                IF  RETURN-VALUE = "NO" THEN RETURN ERROR.
            END. /* IF  bf-docum-est.cod-chave-aces-nf-eletro = c-chave-acesso-re1001a THEN */
        END. /* IF  AVAIL  bf-docum-est THEN DO: */
    END. /* IF  wh-chave-uf-re1001a:SENSITIVE = TRUE THEN */
    ELSE DO:
        /*---[ Conforme chamado 200286 - Solicitante Claudia Rogalsky ]------------------------------------------*/
        FIND FIRST bf-docum-est NO-LOCK
            WHERE  bf-docum-est.serie-docto   = wh-serie-re1001a:SCREEN-VALUE     
            AND    bf-docum-est.nro-docto     = wh-nro-docto-re1001a:SCREEN-VALUE 
            AND    bf-docum-est.cod-emitente  = int(wh-fornecedor-re1001a:SCREEN-VALUE) 
            AND    bf-docum-est.nat-operacao <> wh-natureza-re1001a:SCREEN-VALUE NO-ERROR.
        IF  AVAIL  bf-docum-est THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 27100, INPUT "Procedimento interrompido." + "~~" + 
                                                                  "Documento j† registrado em " + trim(string(bf-docum-est.dt-trans, "99/99/9999":U)) + ", CFOP: " + trim(STRING(bf-docum-est.nat-operacao)) + "." +
                                                                  CHR(10) + "Deseja continuar ?").
            IF  RETURN-VALUE = "NO" THEN RETURN ERROR.
        END. /* IF  AVAIL  bf-docum-est THEN DO: */
    END. /* ELSE DO: */

    /* Conforme chamado 131587 de Talita */
    IF LENGTH(wh-nro-docto-re1001a:SCREEN-VALUE) > 9
    THEN DO:
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 17006,
                          INPUT "N£mero de Documento.~~N£mero do documento n∆o pode ter mais que 9 caracteres.").
       RETURN ERROR.
    END.
END.


IF  p-ind-event  = "AFTER-ASSIGN" AND 
    p-ind-object = "CONTAINER"
THEN DO:
    IF  wh-obs-re1001a:SCREEN-VALUE = "Serviáos"  AND
        p-cod-table                 = "docum-est" AND
        p-row-table                <> ?
    THEN DO:
        FIND docum-est NO-LOCK
            WHERE ROWID(docum-est) = p-row-table NO-ERROR.

        /* Chamado IR63195 */
        IF  AVAIL docum-est                                    AND
                  docum-est.cod-observa                    = 4 AND /* Serviáos */ 
                  INT(SUBSTRING(docum-est.char-2,143,8))  <> 9     /* Sem cobranáa de frete */
        THEN DO:
            FIND CURRENT docum-est EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN OVERLAY(docum-est.char-2,143,8) = "9".
            FIND CURRENT docum-est NO-LOCK NO-ERROR.
        END.
    END.

    FOR FIRST docum-est EXCLUSIVE-LOCK
        WHERE ROWID(docum-est) = p-row-table:
        FOR FIRST int-mod-transp-importacao NO-LOCK
            WHERE int-mod-transp-importacao.cod-estabel  = docum-est.cod-estabel
              AND int-mod-transp-importacao.serie-docto  = docum-est.serie-docto
              AND int-mod-transp-importacao.nat-operacao = docum-est.nat-operacao:
            ASSIGN OVERLAY(docum-est.char-2,143,8) = STRING(int-mod-transp-importacao.cod-modalid-frete)
                   docum-est.nome-transp           = int-mod-transp-importacao.nome-transp.
        END.
        RELEASE int-mod-transp-importacao.
    END.
    RELEASE docum-est.

END.

IF  p-ind-event  = "AFTER-DESTROY-INTERFACE" AND 
    p-ind-object = "CONTAINER" 
THEN DO:
    ASSIGN wh-natureza-re1001a = ?
           wh-obs-re1001a      = ?.
END.

PROCEDURE pi-leave-natureza:

    FIND FIRST int-natur-oper EXCLUSIVE-LOCK
         WHERE int-natur-oper.nat-operacao = wh-natureza-re1001a:SCREEN-VALUE NO-ERROR.

    IF  AVAIL int-natur-oper
    AND int-natur-oper.cod-observa <> 0 THEN DO:
        ASSIGN wh-obs-re1001a:SCREEN-VALUE = {ininc/i03in090.i 04 int-natur-oper.cod-observa}.
    END.

    RELEASE int-natur-oper.

    RUN leaveNatOperacao IN p-wgh-object.

END PROCEDURE.
