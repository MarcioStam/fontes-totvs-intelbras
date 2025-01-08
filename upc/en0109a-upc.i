def new global shared temp-table tt-en0109a-upc-new 
    field it-codigo    like estrutura.it-codigo
    field sequencia    like estrutura.sequencia
    field es-codigo    like estrutura.es-codigo
    field lg-new    as logi
    index id is primary it-codigo
                        sequencia
                        es-codigo
    index id2 lg-new
              es-codigo
              it-codigo
              sequencia.

def new global shared temp-table tt-en0109a-upc-ant no-undo
    field it-codigo    like estrutura.it-codigo
    field sequencia    like estrutura.sequencia
    field es-codigo    like estrutura.es-codigo
    field data-termino like estrutura.data-termino
    index id is primary it-codigo
                        sequencia
                        es-codigo.

def new global shared var h-desativar-en0109a-upc   as handle no-undo.
def new global shared var h-alternativo-en0109a-upc as handle no-undo.
