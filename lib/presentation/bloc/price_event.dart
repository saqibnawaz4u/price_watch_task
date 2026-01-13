abstract class PriceEvent{}

class FetchPrices extends PriceEvent{}
class RefreshPrices extends PriceEvent{}
class ToggleCachedFirst extends PriceEvent{}