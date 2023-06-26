function [errors, offsets] = RDS_CRC(words)
  %Computes the CRC check for FM RDS data.
  [syndrome,correctedWords] = CRCcheck(words);
  offsets = RDSoffset(s);
  errors = offsets == 'X';
end
