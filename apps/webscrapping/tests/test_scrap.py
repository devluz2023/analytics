import pytest
import urllib.request
from scrap import Scrap
from produto import Produto


@pytest.fixture
def scrap():
    limit = 5
    return Scrap(limit)


def test_urls(scrap):
    urls = scrap.geradorUrl()
    for url in urls:
        print(url)
        page =  urllib.request.urlopen(url)
        assert 200 == page.getcode()