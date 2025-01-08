DEFINE TEMP-TABLE {1} NO-UNDO 
  FIELD companyCode AS character
  FIELD checkingAcctCode AS character
  FIELD transactionDate AS date
  FIELD transactionFlow AS integer
  FIELD transactionValue AS decimal decimals 4  
  FIELD companyDescription AS character
  FIELD checkingAcctDescription AS character
  FIELD transactionSequence AS integer
  FIELD postedToGl AS logical
  FIELD cashTransactionType AS character

.
