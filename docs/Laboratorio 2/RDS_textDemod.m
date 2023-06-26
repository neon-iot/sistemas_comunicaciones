function [chars, charsWError] = RDS_textDemod(dbits)

  N=length(dbits);
for i=1:26
  M=floor(N/26)-1;
  words = reshape(dbits(i:(26*M+i-1)),26,M)';
  [synd] = CRCcheck(words);
  offset = RDSoffset(synd);
  noErr(i) = sum(offset~='X');
end
[~,best_i] = max(noErr);

%% Work with the aligned signal, try to correct 1 bit errors:
aligned_dbits = dbits(best_i:26*M+best_i-1);
aligned_words = reshape(aligned_dbits,26,M)';
[synd,corrected] = CRCcheck(double(aligned_words));
offset = RDSoffset(synd);
firstAoffset = find(offset=='A',1);
aligned_words = aligned_words(firstAoffset:end,:); %Dropping words until first A offset
[synd,corrected] = CRCcheck(double(aligned_words));
offset = RDSoffset(synd);
bad_words = find(offset=='X');

aligned_words = corrected;
%Parsing message:

%First word from block:
PI_code = aligned_words(1:4:end,1:16);

%Second word from block:
groupType_code = aligned_words(2:4:end,1:5);
%00100 son radio text (2A) y 10100 son program type name
%00000 son datos básicos de freqs alternativas y nombre del servicio (hasta 8 chars)
PTY = aligned_words(2:4:end,7:11);
seg_address = aligned_words(2:4:end,13:16);

%Get radiotext
RT_segs=find(all(groupType_code - [0 0 1 0 0] == 0,2)); %Segments with radio data: thise where the second word from block has the correct groupType_code
groupType_code = aligned_words((RT_segs-1)*4+2,1:5);
RT_address = aligned_words((RT_segs-1)*4+2,13:16);
%offset((RT_segs-1)*4+4)
char_data = [aligned_words((RT_segs-1)*4+3,1:16) aligned_words((RT_segs-1)*4+4,1:16)]; %2 words with 4 chars total pero relevant block.
char_data =reshape(char_data',8,4*length(RT_segs))';
chars = RDS_byte2char(char_data);
%Get chars that may contain errors:
relevantOffsets = offset([(RT_segs-1)*4+3 (RT_segs-1)*4+4]);
charsWError = relevantOffsets=='X';
charsWError = [charsWError(:,1)*[1 1] charsWError(:,2)*[1 1]];
charsWError = charsWError';
charsWError = charsWError(:);

%Order the chars according to RT_address
RT_addressDec = RT_address*[8;4;2;1];
wrongAddress = offset((RT_segs-1)*4+2)=='X';
prevAddress=-1;
censoredChars = chars;
censoredChars(charsWError==1)='_';
for i =1:length(RT_address)
  currAddress = RT_addressDec(i);
  if currAddress==prevAddress+1
      fprintf(censoredChars((i-1)*4+[1:4]))
  else
      fprintf('\n')
      fprintf(censoredChars((i-1)*4+[1:4]))
  end
  prevAddress=currAddress;
end
end
