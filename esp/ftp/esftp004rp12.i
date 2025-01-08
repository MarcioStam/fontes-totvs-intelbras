/* /* Marca Etiqueta como impressa */                                        */
FIND b1-volume-nf
    WHERE ROWID(b1-volume-nf) = ROWID(volume-nf) EXCLUSIVE-LOCK NO-ERROR.
ASSIGN b1-volume-nf.impresso = YES.
RELEASE b1-volume-nf.
