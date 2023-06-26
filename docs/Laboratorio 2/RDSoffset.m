function offset = RDSoffset(syndrome)
%Also returns whether the CRC16 syndrome is consistent with RDS offset for a block
%(and which)

%IEC 62106-E
%From Table A.1  
%Offset word
%Binary value
%d9 d8 d7 d6 d5 d4 d3 d2 d1 d0
%A  0 0 1 1 1 1 1 1 0 0
%B  0 1 1 0 0 1 1 0 0 0
%C  0 1 0 1 1 0 1 0 0 0
%C' 1 1 0 1 0 1 0 0 0 0
%D  0 1 1 0 1 1 0 1 0 0
%E  0 0 0 0 0 0 0 0 0 0

%Ta ble B-1
% O ffset 
%Offset word d9,d8,d7,...d0  Syndrome    S  9,S 8,S 7,...S 0
%A  0011111100 1111011000
%B  0110011000 1111010100
%C  0101101000 1001011100
%C' 1101010000 1111001100
%D  0110110100 1001011000
S = [1 1 1 1 0 1 1 0 0 0; ...
     1 1 1 1 0 1 0 1 0 0; ...
     1 0 0 1 0 1 1 1 0 0; ...
     1 1 1 1 0 0 1 1 0 0; ...
     1 0 0 1 0 1 1 0 0 0];
     
offset = 'X'*ones(size(syndrome,1),1);
list = ['A','B','C','S','D'];
for i = 1:size(syndrome,1)
  idx = find(all((syndrome(i,:) - S)==0,2));
  if ~isempty(idx)
    offset(i) = list(idx);
  end
end
offset = char(offset);