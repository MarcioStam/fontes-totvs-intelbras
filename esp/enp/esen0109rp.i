catch oStop as progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
        run pi-cria-ocorrencia (input 9999999,
                                input oStop:GetMessage(iNumMessages)).
    end.

    return "NOK".
end catch.

catch eAnyError as progress.Lang.error:
    do iNumMessages = 1 to eAnyError:nummessages:
        run pi-cria-ocorrencia (input 9999999,
                                input eAnyError:GetMessage(iNumMessages)).
    end.

    return "NOK".
end catch.
