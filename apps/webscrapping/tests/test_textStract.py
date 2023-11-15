import pytest
import urllib.request
from textStract import TextStract



@pytest.fixture
def textStract():
    return TextStract()


def test_decimal(textStract):
    number = "1.333"
    result = textStract.convertDouble(number)
    compare = round(float(number), 2)
    
    assert compare == result