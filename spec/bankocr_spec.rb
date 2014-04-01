require 'bankocr'

DIGIT_WIDTH = 3
NUMBER_OF_DIGITS = 9
LINE_LENGTH = NUMBER_OF_DIGITS * DIGIT_WIDTH + 1
LAST_MIDDLE_CHAR = NUMBER_OF_DIGITS * DIGIT_WIDTH - 2

def read(input)
  (0..NUMBER_OF_DIGITS - 1).inject(0) do |sum, position|
    sum + read_value(input, position)
  end
end

def read_value(input, position)
  10**position * read_digit(input, position)
end

def read_digit(input, position)
  middle_char_offset = LAST_MIDDLE_CHAR - DIGIT_WIDTH * position
  if input[middle_char_offset] == '_'
    return 0 if input[middle_char_offset + LINE_LENGTH] == ' '
    2
  else
    1
  end
end

describe BankOCR do

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
end
