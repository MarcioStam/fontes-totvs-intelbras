def new global shared temp-table tt-esen0503 no-undo
    field br-table      as handle
    field wgh-container as handle
    field wgh-browser   as handle
    field ult-camp      as char
    field lg-desc       as logi
    field r-rowid       as rowid.

def var h-qry-hdl as handle no-undo.
def var c-leitura as char   no-undo.

def buffer b-op-ferram for op-ferram.
