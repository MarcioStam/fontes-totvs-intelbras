OUTPUT TO "c:\temp\esccp021.csv" NO-CONVERT.

PUT UNFORMATTED "Fornecedor;Banco Recebedor;C/C;ABA;Swift;Endere‡o;Banco Intermedi rio;C/C;ABA;Swift;Endere‡o" SKIP.
FOR EACH banco-emit NO-LOCK:
    PUT UNFORMATTED STRING(cod-emitente) + ";" +
                    STRING(banco[1]) + ";" +
                    STRING(conta[1]) + ";" +
                    STRING(aba[1]) + ";" +
                    STRING(swift[1]) + ";" +
                    STRING(endereco-1[1] + " " + endereco-4[1] + " " + endereco-3[1] + " " + endereco-2[1]) + ";" +
                    STRING(banco[2]) + ";" +
                    STRING(conta[2]) + ";" +
                    STRING(aba[2]) + ";" +
                    STRING(swift[2]) + ";" +
                    STRING(endereco-1[2] + " " + endereco-4[2] + " " + endereco-3[2] + " " + endereco-2[2]) + ";" SKIP.
END.

OUTPUT CLOSE.
