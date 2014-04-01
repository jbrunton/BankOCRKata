require 'bankocr'

DIGIT_WIDTH = 3
LAST_MIDDLE_CHAR = 25

def read(input)
  if read_digit(input, 2) == 0
    if read_digit(input, 1) == 0
      return read_digit(input, 0)
    end
    return 10 + read_digit(input, 0)
  end
  100 + read_digit(input, 0)
end

def read_digit(input, position)
  if input[LAST_MIDDLE_CHAR - DIGIT_WIDTH * position] == '_'
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

  it 'should recognise one hundred and one' do
    input = <<-END
 _  _  _  _  _  _     _
| || || || || || |  || |  |
|_||_||_||_||_||_|  ||_|  |

    END

    expect(read(input)).to eq(101)
  end
end
