from produto import Produto

class ProdutoBuilder(object):
    
    def __init__(self):
        self.__reviews_amount = None
        self.__cores_disponiveis = None
        self.__frete= None
        self.__titulo = None
        self.__preco = None

    def com_reviews_amount(self, reviews_amount):
        self.__reviews_amount = reviews_amount
        return self
    
    def com_cores_disponiveis(self, cor):
        self.__cores_disponiveis = cor
        return self
    
    def com_frete(self, frete):
        self.__frete= frete
        return self
    
    def com_titulo(self, titulo):
        self.__titulo = titulo
        return self
    
    def com_preco(self, preco):
        self.__preco = preco
        return self
    
    def build(self):
        if(self.__titulo is None):
            raise Exception('Titulo deve ser preenchido')
        return Produto(self.__reviews_amount, 
        self.__cores_disponiveis, self.__frete, self.__titulo, self.__preco)
     