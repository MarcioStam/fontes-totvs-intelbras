/***********************************************************************
**  Programa..: upc\cd0309-upc.p
**  Data......: Setembro/2015 
**  Descricao.: Validar centro de custo x conta 
**  Vers∆o....: 001 - 00/00/2015 - Desenvolvimento Programa
************************************************************************/
{utp/ut-glob.i}
{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel              AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-recven                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-recven                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-cusven                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-cusven                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-devol-produc     AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-devol-produc  AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-desc             AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-desc          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-devol-recta      AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-devol-recta   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-pis-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-pis-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-icms-ft               AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-icms-ft               AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-icmsub-ft             AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-icmsub-ft             AS WIDGET-HANDLE    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cta-difal-orig         AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cc-difal-orig          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cta-difal-dest         AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cc-difal-dest          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cta-fcp                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cc-fcp                 AS WIDGET-HANDLE    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-ipi-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-ipi-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-iss-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-iss-ft                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-cofins-ft             AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-cofins-ft             AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-pis              AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-pis           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-cofins           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-cofins        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-ir-ret                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-ir-ret                AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-inss-retid       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-inss-retid    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-retenc-csll      AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-retenc-csll   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-retenc-pis       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-retenc-pis    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-retenc-cofins    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-retenc-cofins AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cta-retenc-iss       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-ccusto-retenc-iss    AS WIDGET-HANDLE    NO-UNDO.

DEFINE VARIABLE c-char AS CHAR no-undo.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"),
                                  p-wgh-object:file-name,"~/") no-error.
                                  
                                 
/* MESSAGE "Evento " p-ind-event  SKIP    */
/*         "Objeto " p-ind-object SKIP    */
/*         "Nome   " c-char SKIP          */
/*         "Tabela " p-cod-table  SKIP    */
/*         "Rowid  " STRING(p-row-table)  */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF  p-ind-event  = "INITIALIZE" THEN DO: 
   
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        
        IF h-object:TYPE <> "field-group" THEN DO:
        
            IF h-object:NAME = 'cod-estabel' THEN DO:
                ASSIGN wh-cod-estabel = h-object.               
            END.
            IF h-object:NAME = 'sc-recven' THEN DO:
                ASSIGN wh-sc-recven = h-object.            
            END.
            IF h-object:NAME = 'ct-recven' THEN DO:
                ASSIGN wh-ct-recven = h-object.            
            END.
            IF h-object:NAME = 'ct-cusven' THEN DO:
                ASSIGN wh-ct-cusven = h-object.               
            END.
            IF h-object:NAME = 'sc-cusven' THEN DO:
                ASSIGN wh-sc-cusven = h-object.               
            END.
            IF h-object:NAME = 'cod-cta-devol-produc' THEN DO:
                ASSIGN wh-cod-cta-devol-produc = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-devol-produc' THEN DO:
                ASSIGN wh-cod-ccusto-devol-produc = h-object.               
            END.
            IF h-object:NAME = 'cod-cta-desc' THEN DO:
                ASSIGN wh-cod-cta-desc = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-desc' THEN DO:
                ASSIGN wh-cod-ccusto-desc = h-object.               
            END.
            IF h-object:NAME = 'cod-cta-devol-recta' THEN DO:
                ASSIGN wh-cod-cta-devol-recta = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-devol-recta' THEN DO:
                ASSIGN wh-cod-ccusto-devol-recta = h-object.               
            END.
            IF h-object:NAME = 'ct-pis-ft' THEN DO:
                ASSIGN wh-ct-pis-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-pis-ft' THEN DO:
                ASSIGN wh-sc-pis-ft = h-object.               
            END.
            IF h-object:NAME = 'ct-icms-ft' THEN DO:
                ASSIGN wh-ct-icms-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-icms-ft' THEN DO:
                ASSIGN wh-sc-icms-ft = h-object.               
            END.
            IF h-object:NAME = 'ct-icmsub-ft' THEN DO:
                ASSIGN wh-ct-icmsub-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-icmsub-ft' THEN DO:
                ASSIGN wh-sc-icmsub-ft = h-object.               
            END.

            IF h-object:NAME = 'ct-icms-ft' THEN DO:
                ASSIGN wh-ct-icms-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-icms-ft' THEN DO:
                ASSIGN wh-sc-icms-ft = h-object.               
            END.

            IF h-object:NAME = 'c-cta-difal-orig' THEN DO:
                ASSIGN wh-c-cta-difal-orig = h-object.               
            END.
            IF h-object:NAME = 'c-cc-difal-orig' THEN DO:
                ASSIGN wh-c-cc-difal-orig = h-object.               
            END.
            IF h-object:NAME = 'c-cta-difal-dest' THEN DO:
                ASSIGN wh-c-cta-difal-dest = h-object.               
            END.
            IF h-object:NAME = 'c-cc-difal-dest' THEN DO:
                ASSIGN wh-c-cc-difal-dest = h-object.               
            END.
            IF h-object:NAME = 'c-cta-fcp' THEN DO:
                ASSIGN wh-c-cta-fcp = h-object.               
            END.
            IF h-object:NAME = 'c-cc-fcp' THEN DO:
                ASSIGN wh-c-cc-fcp = h-object.               
            END.


            IF h-object:NAME = 'ct-ipi-ft' THEN DO:
                ASSIGN wh-ct-ipi-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-ipi-ft' THEN DO:
                ASSIGN wh-sc-ipi-ft = h-object.               
            END.
            IF h-object:NAME = 'ct-iss-ft' THEN DO:
                ASSIGN wh-ct-iss-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-iss-ft' THEN DO:
                ASSIGN wh-sc-iss-ft = h-object.               
            END.
            IF h-object:NAME = 'ct-cofins-ft' THEN DO:
                ASSIGN wh-ct-cofins-ft = h-object.               
            END.
            IF h-object:NAME = 'sc-cofins-ft' THEN DO:
                ASSIGN wh-sc-cofins-ft = h-object.               
            END.
            IF h-object:NAME = 'cod-cta-pis' THEN DO:
                ASSIGN wh-cod-cta-pis = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-pis' THEN DO:
                ASSIGN wh-cod-ccusto-pis = h-object.               
            END.
            IF h-object:NAME = 'cod-cta-cofins' THEN DO:
                ASSIGN wh-cod-cta-cofins = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-cofins' THEN DO:
                ASSIGN wh-cod-ccusto-cofins = h-object. 
            END.
            IF h-object:NAME = 'ct-ir-ret' THEN DO:
                ASSIGN wh-ct-ir-ret = h-object.               
            END.
            IF h-object:NAME = 'sc-ir-ret' THEN DO:
                ASSIGN wh-sc-ir-ret = h-object. 
            END.
            IF h-object:NAME = 'cod-cta-inss-retid' THEN DO:
                ASSIGN wh-cod-cta-inss-retid = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-inss-retid' THEN DO:
                ASSIGN wh-cod-ccusto-inss-retid = h-object. 
            END.
            IF h-object:NAME = 'cod-cta-retenc-csll' THEN DO:
                ASSIGN wh-cod-cta-retenc-csll = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-retenc-csll' THEN DO:
                ASSIGN wh-cod-ccusto-retenc-csll = h-object. 
            END. 
            IF h-object:NAME = 'cod-cta-retenc-pis' THEN DO:
                ASSIGN wh-cod-cta-retenc-pis = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-retenc-pis' THEN DO:
                ASSIGN wh-cod-ccusto-retenc-pis = h-object. 
            END. 
            IF h-object:NAME = 'cod-cta-retenc-cofins' THEN DO:
                ASSIGN wh-cod-cta-retenc-cofins = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-retenc-cofins' THEN DO:
                ASSIGN wh-cod-ccusto-retenc-cofins = h-object. 
            END. 
            IF h-object:NAME = 'cod-cta-retenc-iss' THEN DO:
                ASSIGN wh-cod-cta-retenc-iss = h-object.               
            END.
            IF h-object:NAME = 'cod-ccusto-retenc-iss' THEN DO:
                ASSIGN wh-cod-ccusto-retenc-iss = h-object. 
            END.            

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.     

END.

/*** pasta Contas I ***/
IF  p-ind-event = "BEFORE-ASSIGN"
and c-char      = 'v04di022.w'    THEN DO: 

    if valid-handle(wh-ct-recven) then do:   
        if wh-ct-recven:screen-value <> '' then
            run pi-valida (input wh-ct-recven:screen-value,
                           input wh-sc-recven:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-recven.
            RETURN 'NOK'.   
        END.
            
    end.

    if valid-handle(wh-ct-cusven) then do:   
        if wh-ct-cusven:screen-value <> '' then
            run pi-valida (input wh-ct-cusven:screen-value,
                           input wh-sc-cusven:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-cusven.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-devol-produc) then do:   
        if wh-cod-cta-devol-produc:screen-value <> '' then
            run pi-valida (input wh-cod-cta-devol-produc:screen-value,
                           input wh-cod-ccusto-devol-produc:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-devol-produc.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-desc) then do:   
        if wh-cod-cta-desc:screen-value <> '' then
            run pi-valida (input wh-cod-cta-desc:screen-value,
                           input wh-cod-ccusto-desc:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-desc.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-devol-recta) then do:   
        if wh-cod-cta-devol-recta:screen-value <> '' then
            run pi-valida (input wh-cod-cta-devol-recta:screen-value,
                           input wh-cod-ccusto-devol-recta:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-devol-recta.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-pis-ft) then do:   
        if wh-ct-pis-ft:screen-value <> '' then
            run pi-valida (input wh-ct-pis-ft:screen-value,
                           input wh-sc-pis-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-pis-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-icms-ft) then do:   
        if wh-ct-icms-ft:screen-value <> '' then
            run pi-valida (input wh-ct-icms-ft:screen-value,
                           input wh-sc-icms-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-icms-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-icmsub-ft) then do:   
        if wh-ct-icmsub-ft:screen-value <> '' then
            run pi-valida (input wh-ct-icmsub-ft:screen-value,
                           input wh-sc-icmsub-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-icmsub-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-ipi-ft) then do:   
        if wh-ct-ipi-ft:screen-value <> '' then
            run pi-valida (input wh-ct-ipi-ft:screen-value,
                           input wh-sc-ipi-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-ipi-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-iss-ft) then do:   
        if wh-ct-iss-ft:screen-value <> '' then
            run pi-valida (input wh-ct-iss-ft:screen-value,
                           input wh-sc-iss-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-iss-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-ct-cofins-ft) then do:   
        if wh-ct-cofins-ft:screen-value <> '' then
            run pi-valida (input wh-ct-cofins-ft:screen-value,
                           input wh-sc-cofins-ft:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-cofins-ft.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-pis) then do:   
        if wh-cod-cta-pis:screen-value <> '' then
            run pi-valida (input wh-cod-cta-pis:screen-value,
                           input wh-cod-ccusto-pis:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-pis.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-cofins) then do:   
        if wh-cod-cta-cofins:screen-value <> '' then
            run pi-valida (input wh-cod-cta-cofins:screen-value,
                           input wh-cod-ccusto-cofins:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-cofins.
            RETURN 'NOK'.   
        END.
    end.

END.

/*** pasta Contas II ***/
IF  p-ind-event = "BEFORE-ASSIGN"
and c-char      = 'v05di022.w'    THEN DO: 

    if valid-handle(wh-ct-ir-ret) then do:   
        if wh-ct-ir-ret:screen-value <> '' then
            run pi-valida (input wh-ct-ir-ret:screen-value,
                           input wh-sc-ir-ret:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-ct-ir-ret.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-inss-retid) then do:   
        if wh-cod-cta-inss-retid:screen-value <> '' then
            run pi-valida (input wh-cod-cta-inss-retid:screen-value,
                           input wh-cod-ccusto-inss-retid:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-inss-retid.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-retenc-csll) then do:   
        if wh-cod-cta-retenc-csll:screen-value <> '' then
            run pi-valida (input wh-cod-cta-retenc-csll:screen-value,
                           input wh-cod-ccusto-retenc-csll:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-retenc-csll.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-retenc-pis) then do:   
        if wh-cod-cta-retenc-pis:screen-value <> '' then
            run pi-valida (input wh-cod-cta-retenc-pis:screen-value,
                           input wh-cod-ccusto-retenc-pis:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-retenc-pis.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-retenc-cofins) then do:   
        if wh-cod-cta-retenc-cofins:screen-value <> '' then
            run pi-valida (input wh-cod-cta-retenc-cofins:screen-value,
                           input wh-cod-ccusto-retenc-cofins:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-retenc-cofins.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-cod-cta-retenc-iss) then do:   
        if wh-cod-cta-retenc-iss:screen-value <> '' then
            run pi-valida (input wh-cod-cta-retenc-iss:screen-value,
                           input wh-cod-ccusto-retenc-iss:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-cod-cta-retenc-iss.
            RETURN 'NOK'.   
        END.
    end.

    if valid-handle(wh-c-cta-difal-orig) then do:   
        run pi-valida (input wh-c-cta-difal-orig:screen-value,
                       input wh-c-cc-difal-orig:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-c-cta-difal-orig.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-c-cta-difal-dest) then do:   
            run pi-valida (input wh-c-cta-difal-dest:screen-value,
                           input wh-c-cc-difal-dest:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-c-cta-difal-dest.
            RETURN 'NOK'.   
        END.
    end.
    if valid-handle(wh-c-cta-fcp) then do:   
            run pi-valida (input wh-c-cta-fcp:screen-value,
                           input wh-c-cc-fcp:screen-value).
        
        if return-value <> 'OK' THEN DO:
            APPLY "ENTRY":U TO wh-c-cta-fcp.
            RETURN 'NOK'.   
        END.
    end.



END.


IF  p-ind-event = "DESTROY"
THEN DO:
    ASSIGN wh-cod-estabel                = ?
           wh-ct-recven                  = ?
           wh-sc-recven                  = ?
           wh-ct-cusven                  = ?
           wh-sc-cusven                  = ?
           wh-cod-cta-devol-produc       = ?
           wh-cod-ccusto-devol-produc    = ?
           wh-cod-cta-desc               = ?
           wh-cod-ccusto-desc            = ?
           wh-cod-cta-devol-recta        = ?
           wh-cod-ccusto-devol-recta     = ?
           wh-ct-pis-ft                  = ?
           wh-sc-pis-ft                  = ?
           wh-ct-icms-ft                 = ?
           wh-sc-icms-ft                 = ?
           wh-ct-icmsub-ft               = ?
           wh-sc-icmsub-ft               = ?
           wh-c-cta-difal-orig           = ?
           wh-c-cc-difal-orig            = ?
           wh-c-cta-difal-dest           = ?
           wh-c-cc-difal-dest            = ?
           wh-c-cta-fcp                  = ?
           wh-c-cc-fcp                   = ?
           wh-ct-ipi-ft                  = ?
           wh-sc-ipi-ft                  = ?
           wh-ct-iss-ft                  = ?
           wh-sc-iss-ft                  = ?
           wh-ct-cofins-ft               = ?
           wh-sc-cofins-ft               = ?
           wh-cod-cta-pis                = ?
           wh-cod-ccusto-pis             = ?
           wh-cod-cta-cofins             = ?
           wh-cod-ccusto-cofins          = ?
           wh-ct-ir-ret                  = ?
           wh-sc-ir-ret                  = ?
           wh-cod-cta-inss-retid         = ?
           wh-cod-ccusto-inss-retid      = ?
           wh-cod-cta-retenc-csll        = ?
           wh-cod-ccusto-retenc-csll     = ?
           wh-cod-cta-retenc-pis         = ?
           wh-cod-ccusto-retenc-pis      = ?
           wh-cod-cta-retenc-cofins      = ?
           wh-cod-ccusto-retenc-cofins   = ?
           wh-cod-cta-retenc-iss         = ?
           wh-cod-ccusto-retenc-iss      = ?.
END.


/******************************************************************************************/
Procedure pi-valida:

    def input param p-conta as char no-undo.
    def input param p-custo as char no-undo.
    
    def var p-estab as char no-undo.
    
    EMPTY TEMP-TABLE tt_log_erro.
    
    if valid-handle (wh-cod-estabel) then
        assign p-estab = wh-cod-estabel:screen-value.
    else
        assign p-estab = ''.
        
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-ep-codigo-usuario,                        /* EMPRESA EMS2 */
                                                    input  p-estab,                                    /* ESTABELECIMENTO EMS2 */
                                                    input  "",                                         /* UNIDADE NEG‡CIO */
                                                    input  "",                                         /* PLANO CONTAS */ 
                                                    input  replace(p-conta,".",""),                    /* CONTA */
                                                    input  "",                                         /* PLANO CCUSTO */ 
                                                    input  p-custo,                                    /* CCUSTO */
                                                    input  today,                                      /* DATA TRANSACAO */
                                                    output table tt_log_erro).                         /* ERROS */
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

    IF  CAN-FIND(FIRST tt_log_erro) THEN DO:
        FOR EACH tt_log_erro NO-LOCK:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Conta com Problema : " + string(ttv_num_cod_erro) + " " + ttv_des_msg_erro).
        END. 
        return "NOK".           
    END.
    ELSE 
        RETURN "OK". 

end procedure.


    
