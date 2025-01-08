DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
 

ASSIGN v_cod_usuar_corren = "se888010".
    
RUN esp/cpp/escpp031rp.p PERSISTENT SET h-handle (?,
                                                  INPUT TABLE tt-raw-digita).  

RUN piEnviaEmail IN h-handle (INPUT "1,2,3,4",
                              INPUT "5,6,7,8").

IF VALID-HANDLE(h-handle) THEN
    DELETE PROCEDURE h-handle.
