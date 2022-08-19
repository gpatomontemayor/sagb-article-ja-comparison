# Class that contains all the information of a player
class Player:
    def __init__(self, name, nbaid, nbateamid, nbaseasons, bballrefid, bballrefseasons):
        self._name = name
        self._nbaid = nbaid
        self._nbateamid = nbateamid
        self._nbaseasons = nbaseasons

    def name(self):
        return self._name
    
    def nbaid(self):
        return self._nbaid
    
    def nbateamid(self):
        return self._nbateamid
    
    def nbaseasons(self):
        return self._nbaseasons