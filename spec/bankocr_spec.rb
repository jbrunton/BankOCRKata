require 'bankocr'

DIGIT_WIDTH = 3
LAST_MIDDLE_CHAR = 25

def read(input)
  [2,1,0].inject(0) do |sum, position|
    sum + read_value(input, position)
  end
end

def read_value(input, position)
  10**position * read_digit(input, position)
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
