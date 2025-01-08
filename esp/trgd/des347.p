TRIGGER PROCEDURE FOR DELETE OF ns-volume.   

DEFINE VARIABLE hBuffer2     AS HANDLE NO-UNDO.
DEFINE VARIABLE iFieldNumber AS INTEGER NO-UNDO.
DEFINE VARIABLE hfield2      AS HANDLE  NO-UNDO.
DEFINE VARIABLE cValor2      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iCount       AS INTEGER                NO-UNDO INITIAL 1.

DEFINE VARIABLE i-cont-campos AS INTEGER     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHAR NO-UNDO.

DEFINE VARIABLE oIPHostEntry AS System.Net.IPHostEntry NO-UNDO.
DEFINE VARIABLE oIPAddress   AS System.Net.IPAddress   NO-UNDO.
DEFINE VARIABLE cIPAddresses AS CHARACTER              NO-UNDO.

oIPHostEntry = System.Net.Dns:GetHostEntry(System.Net.Dns:GetHostName()) NO-ERROR.

oIPAddress = CAST(oIPHostEntry:AddressList:GetValue(iCount),"System.Net.IPAddress") NO-ERROR.
IF ERROR-STATUS:NUM-MESSAGES GT 0 THEN
    LEAVE.

cIPAddresses = cIPAddresses + (IF (cIPAddresses GT "") EQ TRUE THEN CHR(10) ELSE "") + oIPAddress:ToString().
    
hbuffer2 = BUFFER ns-volume:HANDLE.                 

ASSIGN i-cont-campos = 0.

DO iFieldNumber = 1 TO hbuffer2:NUM-FIELDS:
        
    hfield2 = hbuffer2:BUFFER-FIELD(iFieldNumber).            
                      
    IF iFieldNumber = 1 THEN DO:                

        CREATE ns-volume-hist.
        ASSIGN ns-volume-hist.id-hist       = NEXT-VALUE(seq-ns-volume-hist)
               ns-volume-hist.volume-pai    = ns-volume.volume-pai
               ns-volume-hist.sequencia     = ns-volume.sequencia
               ns-volume-hist.volume-filho  = ns-volume.volume-filho
               ns-volume-hist.data          = NOW                       
               ns-volume-hist.cod-usuario   = c-seg-usuario
               ns-volume-hist.cd-programa   = PROGRAM-NAME(2)
               ns-volume-hist.ds-hostname   = System.Net.Dns:GetHostName()
               ns-volume-hist.ds-ip         = cIPAddresses
               ns-volume-hist.tipo-movto    = "E"
               ns-volume-hist.cd-recid      = RECID(ns-volume).

    END.                       
    
    IF hfield2:EXTENT > 0 THEN DO:
        DO iCount = 1 TO hfield2:EXTENT: 

            IF hfield2:BUFFER-VALUE(iCount) = ? THEN DO:
                ASSIGN cValor2 = ''.                        
            END.
            ELSE DO:
                ASSIGN cValor2 = hfield2:BUFFER-VALUE(iCount).
            END.                      
            
            ASSIGN i-cont-campos = i-cont-campos + 1.

            CREATE ns-volume-hist-det.
            ASSIGN ns-volume-hist-det.id-hist       = ns-volume-hist.id-hist
                   ns-volume-hist-det.volume-pai    = ns-volume-hist.volume-pai
                   ns-volume-hist-det.sequencia     = ns-volume-hist.sequencia
                   ns-volume-hist-det.volume-filho  = ns-volume-hist.volume-filho                           
                   ns-volume-hist-det.cod-campo     = hfield2:NAME
                   ns-volume-hist-det.ds-campo      = hfield2:LABEL
                   ns-volume-hist-det.seq-det       = i-cont-campos
                   ns-volume-hist-det.valor-antes   = cValor2
                   ns-volume-hist-det.valor-depois  = cValor2.
            
        END.
    END.                
    ELSE DO:
            
        IF hfield2:BUFFER-VALUE = ? THEN DO:
            ASSIGN cValor2 = ''.                        
        END.
        ELSE DO:
            ASSIGN cValor2 = hfield2:BUFFER-VALUE.
        END.               

        ASSIGN i-cont-campos = i-cont-campos + 1.
        
        CREATE ns-volume-hist-det.
        ASSIGN ns-volume-hist-det.id-hist       = ns-volume-hist.id-hist
               ns-volume-hist-det.volume-pai    = ns-volume-hist.volume-pai
               ns-volume-hist-det.sequencia     = ns-volume-hist.sequencia
               ns-volume-hist-det.volume-filho  = ns-volume-hist.volume-filho                           
               ns-volume-hist-det.cod-campo     = hfield2:NAME
               ns-volume-hist-det.ds-campo      = hfield2:LABEL
               ns-volume-hist-det.seq-det       = i-cont-campos
               ns-volume-hist-det.valor-antes   = cValor2
               ns-volume-hist-det.valor-depois  = cValor2.
                               
    END.              
END.







