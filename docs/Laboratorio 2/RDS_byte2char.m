function chars = RDS_byte2char(bytes)

N=size(bytes,1);
prefixes = bytes(:,1:4)*[8;4;2;1];
suffixes = bytes(:,5:8)*[8;4;2;1];
for i=1:N  
switch prefixes(i)
  case 0 %Special codes (EOF, break line)
    switch suffixes(i)
      case 13 %Carriage return
        chars(i) = '#';
      case 10% Line break
        chars(i) = '\';
      otherwise
        chars(i) = '_';
      end
        
  case 2 %Special chars
    switch suffixes(i)
      case 0
        chars(i) = ' ';
      case 1
        chars(i) = '!';
      case 6
        chars(i) = '&';
      case 7
        chars(i) = '''';
      case 12
        chars(i) = ',';
      case 13
        chars(i) = '-';
      case 14
        chars(i) = '.';
      case 15
        chars(i) = '/';
      otherwise
        chars(i) = '_';
    end
  case 3 %Numbers
    chars(i) = '0'+suffixes(i); %Valid until 9, obvs
  case 4 %Uppercase letters
    chars(i) = 'A'-1+suffixes(i);
  case 5 %More uppercase
    chars(i) = 'Q'-1+suffixes(i);
  case 6 %lower case
    chars(i) = 'a'-1+suffixes(i);
  case 7 %more lower case
    chars(i) = 'q'-1+suffixes(i);
  otherwise
    chars(i)='_'; %Unimplemented
end
end
chars = char(chars);