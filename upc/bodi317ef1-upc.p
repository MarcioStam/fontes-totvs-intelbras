
/*****************************************************************************************
**  Programa.: BODI317EF1-upc.p
**  Descricao: Registra cidade/estado/pais, referente ao local de prestacao
**             de servico para integracao com o CW NFSe
**  ATUALIZACAO: 06/01/2011
*****************************************************************************************/
{include/i-epc200.i bodi317ef}

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE r-it-nota-fisc AS ROWID       NO-UNDO.
DEFINE VARIABLE r-wt-it-docto  AS ROWID       NO-UNDO.

DEF VAR c-cidade-ser AS CHAR NO-UNDO.
DEF VAR c-uf-ser     AS CHAR NO-UNDO.
DEF VAR c-pais-ser   AS CHAR NO-UNDO.

IF  p-ind-event = "afterCriaItNotaFisc" THEN DO:
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "afterCriaItNotaFisc"
           AND tt-epc.cod-parameter = "Rowid_WtItDocto_ItNotaFisc":U NO-ERROR.

    IF  AVAIL tt-epc THEN DO:

        ASSIGN r-wt-it-docto  = TO-ROWID(ENTRY(1,tt-epc.val-parameter,","))
               r-it-nota-fisc = TO-ROWID(ENTRY(2,tt-epc.val-parameter,",")).

        FIND FIRST wt-it-docto NO-LOCK
             WHERE ROWID(wt-it-docto) = r-wt-it-docto NO-ERROR.

        IF  AVAIL wt-it-docto THEN DO:

            FIND FIRST it-nota-fisc
                 WHERE ROWID(it-nota-fisc) = r-it-nota-fisc NO-LOCK NO-ERROR.

            IF  AVAIL it-nota-fisc THEN DO TRANS:

                FIND FIRST esp-ext-wt-it-docto EXCLUSIVE-LOCK
                     WHERE esp-ext-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto
                       AND esp-ext-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-ERROR.


                FIND FIRST wt-docto NO-LOCK
                    WHERE wt-docto.seq-wt-docto = wt-it-docto.seq-wt-docto NO-ERROR.

                IF  AVAIL esp-ext-wt-it-docto THEN
                    ASSIGN esp-ext-wt-it-docto.nr-nota-fis = it-nota-fisc.nr-nota-fis
                           esp-ext-wt-it-docto.cod-estabel = it-nota-fisc.cod-estabel
                           esp-ext-wt-it-docto.serie       = it-nota-fisc.serie
                           esp-ext-wt-it-docto.it-codigo   = it-nota-fisc.it-codigo.
                ELSE DO:
                    RUN pi-cidade-prestacao-servico (INPUT wt-docto.nome-abrev,
                                                     INPUT wt-it-docto.nr-pedcli,
                                                     INPUT wt-it-docto.nr-seq-ped,
                                                     INPUT wt-it-docto.it-codigo,
                                                     INPUT wt-it-docto.cod-refer,
                                                     OUTPUT c-cidade-ser,
                                                     OUTPUT c-uf-ser,
                                                     OUTPUT c-pais-ser).
                    IF  c-uf-ser <> "" THEN DO:
                        CREATE esp-ext-wt-it-docto.
                        ASSIGN esp-ext-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto   
                               esp-ext-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                               esp-ext-wt-it-docto.nr-nota-fis     = it-nota-fisc.nr-nota-fis 
                               esp-ext-wt-it-docto.cod-estabel     = it-nota-fisc.cod-estabel 
                               esp-ext-wt-it-docto.serie           = it-nota-fisc.serie       
                               esp-ext-wt-it-docto.it-codigo       = it-nota-fisc.it-codigo.  
    
                        ASSIGN esp-ext-wt-it-docto.cidade = c-cidade-ser 
                               esp-ext-wt-it-docto.estado = c-uf-ser     
                               esp-ext-wt-it-docto.pais   = c-pais-ser.  
                    END.
                END.
                FIND CURRENT esp-ext-wt-it-docto NO-LOCK NO-ERROR.
            END.
        END.
    END.
END.

IF  p-ind-event = "EndEfetivaNota":U THEN DO:

    FIND FIRST tt-epc 
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "ROWID(nota-fiscal)":U NO-ERROR.
    IF  AVAIL tt-epc THEN DO:

        FIND FIRST nota-fiscal NO-LOCK
             WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        
        IF  AVAIL nota-fiscal THEN DO TRANS:

            IF  NOT CAN-FIND(FIRST esp-ext-ser-estab
                             WHERE esp-ext-ser-estab.cod-estabel = nota-fiscal.cod-estabel
                               AND esp-ext-ser-estab.serie       = nota-fiscal.serie
                               AND esp-ext-ser-estab.emite-rps) THEN
                NEXT.

            FIND FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
                 WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                   AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                   AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

            IF  NOT AVAIL esp-ext-nota-fiscal THEN DO:

                CREATE esp-ext-nota-fiscal.
                ASSIGN esp-ext-nota-fiscal.cod-estabel  = nota-fiscal.cod-estabel
                       esp-ext-nota-fiscal.serie        = nota-fiscal.serie
                       esp-ext-nota-fiscal.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       esp-ext-nota-fiscal.hr-emis-nota = STRING(TIME,"HH:MM:SS").
                
                FIND FIRST esp-ext-wt-it-docto NO-LOCK
                     WHERE esp-ext-wt-it-docto.nr-nota-fis = esp-ext-nota-fiscal.nr-nota-fis
                       AND esp-ext-wt-it-docto.cod-estabel = esp-ext-nota-fiscal.cod-estabel
                       AND esp-ext-wt-it-docto.serie       = esp-ext-nota-fiscal.serie NO-ERROR.
                IF  AVAIL esp-ext-wt-it-docto THEN DO:

                    ASSIGN esp-ext-nota-fiscal.cidade = esp-ext-wt-it-docto.cidade
                           esp-ext-nota-fiscal.estado = esp-ext-wt-it-docto.estado
                           esp-ext-nota-fiscal.pais   = esp-ext-wt-it-docto.pais.
                END.
                ELSE DO:

                    FIND FIRST esp-ext-ser-estab NO-LOCK
                         WHERE esp-ext-ser-estab.cod-estabel             = nota-fiscal.cod-estabel
                           AND esp-ext-ser-estab.serie                   = nota-fiscal.serie
                           AND esp-ext-ser-estab.local-padrao-prest-serv = 2 NO-ERROR.

                    IF  AVAIL esp-ext-ser-estab THEN DO:
                    
                        FOR FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:

                            ASSIGN esp-ext-nota-fiscal.cidade = emitente.cidade
                                   esp-ext-nota-fiscal.estado = emitente.estado
                                   esp-ext-nota-fiscal.pais   = emitente.pais.
                        END.
                    END.
                    ELSE DO:

                        FOR FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel:

                            ASSIGN esp-ext-nota-fiscal.cidade = estabelec.cidade
                                   esp-ext-nota-fiscal.estado = estabelec.estado
                                   esp-ext-nota-fiscal.pais   = estabelec.pais.
                        END.
                    END.
                END.
            END.
            ELSE
                ASSIGN esp-ext-nota-fiscal.hr-emis-nota = STRING(TIME,"HH:MM:SS").
        
        END.
    END.
END.

{upc/upc-ft4004nfse.i} /* pi-cidade-prestacao-servico */

RETURN "OK".

