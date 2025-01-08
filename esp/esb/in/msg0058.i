{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0058 NO-UNDO XML-NODE-NAME 'MSG0058'
   FIELD idm            AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoContato              AS CHARACTER
   FIELD CodigoCliente              AS INTEGER
   FIELD Canal                      AS CHARACTER
   FIELD TipoObjetoCanal	        AS CHARACTER
   FIELD CodigoRepresentante	    AS INTEGER
   FIELD NomeContato                AS CHARACTER
   FIELD SegundoNome	            AS CHARACTER
   FIELD Sobrenome	                AS CHARACTER
   FIELD DescricaoContato           AS CHARACTER
   FIELD Email	                    AS CHARACTER
   FIELD EmailAlternativo	        AS CHARACTER
   FIELD Telefone	                AS CHARACTER
   FIELD Ramal	                    AS CHARACTER
   FIELD TelefoneAlternativo	    AS CHARACTER
   FIELD RamalTelefoneAlternativo   AS CHARACTER
   FIELD Celular	                AS CHARACTER
   FIELD NomeAssistente	            AS CHARACTER
   FIELD TelefoneAssistente	        AS CHARACTER
   FIELD NomeGerente	            AS CHARACTER
   FIELD TelefoneGerente	        AS CHARACTER
   FIELD Fax	                    AS CHARACTER
   FIELD RamalFax	                AS CHARACTER
   FIELD Area	                    AS INTEGER
   FIELD Cargo	                    AS INTEGER
   FIELD DescricaoCargo	            AS CHARACTER
   FIELD Funcao	                    AS INTEGER
   FIELD MetodoEntrega	            AS INTEGER
   FIELD DataEspecial	            AS DATE
   FIELD SuspensaoCredito           AS LOGICAL
   FIELD Sexo	                    AS INTEGER
   FIELD TipoContato	            AS INTEGER
   FIELD CondicaoFrete              AS INTEGER
   FIELD LimiteCredito	            AS DECIMAL
   FIELD DataNascimento	            AS DATE
   FIELD Moeda	                    AS CHARACTER
   FIELD ListaPreco	                AS CHARACTER
   FIELD Saudacao	                AS CHARACTER
   FIELD Formacao	                AS CHARACTER
   FIELD Escolaridade	            AS INTEGER
   FIELD EstadoCivil	            AS INTEGER
   FIELD Nacionalidade	            AS CHARACTER
   FIELD Naturalidade	            AS CHARACTER
   FIELD RG	                        AS CHARACTER
   FIELD OrgaoExpeditor	            AS CHARACTER
   FIELD CPF	                    AS CHARACTER
   FIELD CNPJ	                    AS CHARACTER
   FIELD Procuracao	                AS CHARACTER
   FIELD TemFilhos                  AS INTEGER
   FIELD NomeFilhos	                AS CHARACTER
   FIELD NumeroFilhos	            AS INTEGER
   FIELD Departamento	            AS CHARACTER
   FIELD ClientePotencialOriginador AS CHARACTER
   FIELD ContatoNFE	                AS INTEGER
   FIELD NumeroContato	            AS CHARACTER
   FIELD Proprietario	            AS CHARACTER
   FIELD TipoProprietario	        AS CHARACTER
   FIELD PapelCanal	                AS INTEGER
   FIELD Loja	                    AS CHARACTER
   FIELD Situacao                   AS INTEGER
   FIELD Regiao                     AS CHAR
   FIELD NomeConjuge                AS CHAR.

DEFINE TEMP-TABLE EnderecoPrincipal NO-UNDO XML-NODE-NAME 'EnderecoPrincipal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit
   FIELD TipoEndereco                       AS INT /*1*/
   FIELD CaixaPostal                        AS CHAR
   FIELD CEP                                LIKE nota-fiscal.cep
   FIELD Logradouro                         AS CHAR
   FIELD Numero                             AS INT 
   FIELD Complemento                        AS CHAR
   FIELD Bairro                             LIKE nota-fiscal.bairro    
   FIELD NomeCidade                         LIKE nota-fiscal.cidade    
   FIELD Cidade                             LIKE nota-fiscal.cidade    
   FIELD UF                                 LIKE nota-fiscal.estado    
   FIELD Estado                             LIKE nota-fiscal.estado    
   FIELD NomePais                           LIKE nota-fiscal.pais      
   FIELD Pais                               LIKE nota-fiscal.pais      
   FIELD NomeContato                        AS CHAR   
   FIELD Telefone                           LIKE emitente.telefone  
   FIELD Fax                                LIKE emitente.telefax.

DEFINE TEMP-TABLE msg0058r NO-UNDO XML-NODE-NAME 'MSG0058R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoContato    AS CHARACTER INITIAL ?
   FIELD Proprietario	  AS CHARACTER INITIAL ?
   FIELD TipoProprietario AS CHARACTER INITIAL ?.

   

