def {1} var ti-nnumero      as dec format "99999999999" decimals 0 no-undo.
def {1} var ti-banco        as i format "999" no-undo.
def {1} var ti-ag-cedente   as i  format "9999" no-undo.
def {1} var ti-ccorrente    as i  format "99999999" no-undo.
def {1} var ti-dac-agcc     as i  format "9" no-undo.
def {1} var ti-carteira     as i  format "99" no-undo.
def {1} var td-valor        as de format ">>,>>>,>>9.99" decimals 3  no-undo.
def {1} var tc-linha-dig    as c format "x(58)" no-undo.
def {1} var tc-nrbarr       as c format "x(44)" no-undo.
def {1} var ti-dac-barra    as i format "9"     NO-UNDO INITIAL ''.
def {1} var td-vencimento   as date format "99/99/9999" no-undo.
def {1} var tc-bco-compens  as c format "999-9".
def {1} var tc-nome-banco   as c format "x(15)".
def {1} var tc-nome-est     as c  format "x(50)" no-undo.
def {1} var i-dig-cart      as int format 9.
def {1} var h-acomp         as handle no-undo.

def {1} var ti-zeros                as i  format "999".
def {1} var ti-moeda                as i  format "9"    init 9.
def {1} var ti-ixtab                as i.
def {1} var ti-multiplicador        as i.
def {1} var td-soma                 as i.
def {1} var tc-cpo-1                as c  format "x(9)".
def {1} var tc-cpo-2                as c  format "x(10)".
def {1} var tc-cpo-3                as c  format "x(10)".
def {1} var tc-cpo-4                as c  format "x".
def {1} var tc-cpo-5                as c  format "x(14)" INITIAL ''.
def {1} var ti-dac-cpo-1            as i  format "9".
def {1} var ti-dac-cpo-2            as i  format "9".
def {1} var ti-dac-cpo-3            as i  format "9".
def {1} var ti-valor-mod-10         as i  format "99".

