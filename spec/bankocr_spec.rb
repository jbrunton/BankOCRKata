require 'bankocr'

DIGIT_WIDTH = 3
NUMBER_OF_DIGITS = 9
LINE_LENGTH = NUMBER_OF_DIGITS * DIGIT_WIDTH + 1

def read(input)
  (0..NUMBER_OF_DIGITS - 1).inject(0) do |sum, position|
    sum + read_value(input, position)
  end
end

def read_value(input, position)
  10**position * read_digit(input, position)
end

def read_digit(input, position)
  read_digit_char = lambda do |line, offset|
    read_char(input, position, line, offset)
  end
  if read_digit_char.(0, 1) == '_'
    if read_digit_char.(1, 1) == ' '
      return 0 if read_digit_char.(1, 0) == '|'
      return 7
    end
    return 2 if read_digit_char.(2, 2) == ' '
    return 3 if read_digit_char.(1, 0) == ' '
    if read_digit_char.(2, 0) == ' '
      return 5 if read_digit_char.(1, 2) == ' '
      return 9
    end
    return 6 if read_digit_char.(1, 2) == ' '
    8
  else
    return 1 if read_digit_char.(1, 0) == ' '
    4
  end
end

def read_char(input, position, line, offset)
  return input[LINE_LENGTH * line + DIGIT_WIDTH * (NUMBER_OF_DIGITS - position - 1) + offset]
end

def checksum(account_number)
  (0..NUMBER_OF_DIGITS).inject(0) do |sum, digit|
    sum + get_checksum_component(account_number, digit)
  end % 11
end

def get_checksum_component(number, digit)
  get_decimal_digit(number, digit) * (digit + 1)
end

def get_decimal_digit(number, digit)
  number % 10**(digit + 1) / 10**digit
end

def valid_account?(account_number)
  checksum(account_number) == 0
end

describe BankOCR do
  context 'reading numbers' do
    it 'should recognize zero' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || || |
|_||_||_||_||_||_||_||_||_|

      END
  
      expect(read(input)).to eq(0)
    end
  
    it 'should recognize one' do
      input = <<-END
 _  _  _  _  _  _  _  _    
| || || || || || || || |  |
|_||_||_||_||_||_||_||_|  |

      END
  
      expect(read(input)).to eq(1)
    end
  
    it 'should recognize ten' do
      input = <<-END
 _  _  _  _  _  _  _     _ 
| || || || || || || |  || |
|_||_||_||_||_||_||_|  ||_|

      END
  
      expect(read(input)).to eq(10)
    end
  
    it 'should recognise eleven' do
      input = <<-END
 _  _  _  _  _  _  _       
| || || || || || || |  |  |
|_||_||_||_||_||_||_|  |  |

      END
  
      expect(read(input)).to eq(11)
    end
  
    it 'should recognise one hundred' do
      input = <<-END
 _  _  _  _  _  _     _  _ 
| || || || || || |  || || |
|_||_||_||_||_||_|  ||_||_|

      END
  
      expect(read(input)).to eq(100)
    end
  
    it 'should recognise one hundred and one' do
      input = <<-END
 _  _  _  _  _  _     _    
| || || || || || |  || |  |
|_||_||_||_||_||_|  ||_|  |

      END
  
      expect(read(input)).to eq(101)
    end
  
    it 'should recognise the highest value digit' do
      input = <<-END
    _  _     _  _     _    
  || || |  || || |  || |  |
  ||_||_|  ||_||_|  ||_|  |

      END
  
      expect(read(input)).to eq(100100101)
    end
  
    it 'should recognize two' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || | _|
|_||_||_||_||_||_||_||_||_ 

      END
  
      expect(read(input)).to eq(2)
    end
  
    it 'should recognize three' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || | _|
|_||_||_||_||_||_||_||_| _|

      END
  
      expect(read(input)).to eq(3)
    end
  
    it 'should recognize four' do
      input = <<-END
 _  _  _  _  _  _  _  _    
| || || || || || || || ||_|
|_||_||_||_||_||_||_||_|  |

      END
  
      expect(read(input)).to eq(4)
    end
  
    it 'should recognize five' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || ||_ 
|_||_||_||_||_||_||_||_| _|

      END
  
      expect(read(input)).to eq(5)
    end
  
    it 'should recognize six' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || ||_ 
|_||_||_||_||_||_||_||_||_|

      END
  
      expect(read(input)).to eq(6)
    end
  
    it 'should recognize seven' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || |  |
|_||_||_||_||_||_||_||_|  |

      END
  
      expect(read(input)).to eq(7)
    end
  
    it 'should recognize eight' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || ||_|
|_||_||_||_||_||_||_||_||_|

      END
  
      expect(read(input)).to eq(8)
    end
  
    it 'should recognize nine' do
      input = <<-END
 _  _  _  _  _  _  _  _  _ 
| || || || || || || || ||_|
|_||_||_||_||_||_||_||_| _|

      END
  
      expect(read(input)).to eq(9)
    end
    
    it 'should recognize any digit in any position' do
      input = <<-END
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|
                           
      END
      
      expect(read(input)).to eq(123456789)
    end
  end
  
  context 'checksums' do
    (0..9).each do |account_number|
      it "should give #{account_number} for #{account_number}" do
        expect(checksum(account_number)).to eq(account_number)
      end
    end
    
    {
        10 => 2,
        11 => 3,
        19 => 0,
        20 => 4,
        60 => 1,
        100 => 3,
        101 => 4,
        111 => 6,
        221 => 0,
        123456789 => 0,
        987654321 => 10
    }.each_pair do |account_number, expected_checksum|
      it "should give #{expected_checksum} for the account number #{account_number}" do
        expect(checksum(account_number)).to eq(expected_checksum)
      end
    end
  end
  
  context 'valid_account?' do
    it 'should return true for 0' do
      expect(valid_account?(0)).to eq(true)
    end
    
    it 'should return true for 123456789' do
      expect(valid_account?(123456789)).to eq(true)
    end
    
    it 'should return false for 987654321' do
      expect(valid_account?(987654321)).to eq(false)
    end
  end
end
