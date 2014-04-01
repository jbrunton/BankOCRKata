require 'bankocr'

DIGIT_WIDTH = 3
LAST_MIDDLE_CHAR = 25

def read(input)
  if input[LAST_MIDDLE_CHAR - DIGIT_WIDTH * 2] == '_'
    if input[LAST_MIDDLE_CHAR - DIGIT_WIDTH] == '_'
      return read_last_digit(input)
    end
    return 10 + read_last_digit(input)
  end
  100
end

def read_last_digit(input)
  if input[LAST_MIDDLE_CHAR] == '_'
    0
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
end
