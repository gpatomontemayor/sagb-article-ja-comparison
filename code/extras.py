class Player:
    def __init__(self, name, nbaid, nbateamid, nbaseasons, bballrefid, bballrefseasons):
        self._name = name
        self._nbaid = nbaid
        self._nbateamid = nbateamid
        self._nbaseasons = nbaseasons
        self._bballrefid = bballrefid
        self._bballrefseasons = bballrefseasons

    def name(self):
        return self._name
    
    def nbaid(self):
        return self._nbaid
    
    def nbateamid(self):
        return self._nbateamid
    
    def nbaseasons(self):
        return self._nbaseasons

    def bballrefid(self):
        return self._bballrefid
    
    def bballrefseasons(self):
        return self._bballrefseasons