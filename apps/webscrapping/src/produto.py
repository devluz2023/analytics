
class Produto:
    
    def __init__(self, reviews_amount, cores_disponiveis, frete, titulo, preco):
        self.__reviews_amount = reviews_amount
        self.__cores_disponiveis = cores_disponiveis
        self.__frete = frete
        self.__titulo = titulo
        self.__preco = preco


    @property
    def reviews_amount(self):
        return self.__reviews_amount
    
    @reviews_amount.setter
    def reviews_amount(self, reviews_amount):
        self.__reviews_amount = reviews_amount

    @property
    def cores_disponiveis(self):
        return self.__cores_disponiveis
    
    @cores_disponiveis.setter
    def cores_disponiveis(self, cores_disponiveis):
        self.__cores_disponiveis = cores_disponiveis

    @property
    def frete(self):
        return self.__frete
    
    @frete.setter
    def frete(self, frete):
        self.__frete = frete

    @property
    def titulo(self):
        return self.__titulo
    
    @titulo.setter
    def titulo(self, titulo):
        self.__titulo = titulo
        
    
    @property
    def preco(self):
        return self.preco
    
    @preco.setter
    def preco(self, preco):
        self.__preco = preco