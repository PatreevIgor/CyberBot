class Constant
  NEW_ITEMS_STATUS               = 'new'.freeze
  MAIN_ITEMS_STATUS              = 'main'.freeze
  ACTUALLY_MAIN_ITEMS_STATUS     = 'main_actually'.freeze
  NOT_ACTUALLY_MAIN_ITEMS_STATUS = 'main_not_actually'.freeze
  NOT_SALE_ITEMS_STATUS          = 'not sale'.freeze
  SALE_ITEMS_STATUS              = 'sale on'.freeze

  ITEM_HASH_CLASS_ID_KEY         = 'classid'.freeze
  ITEM_HASH_INSTANCE_ID_KEY      = 'instanceid'.freeze
  ITEM_HASH_PRICE_KEY            = 'price'.freeze
  ITEM_HASH_HASH_NAME_KEY        = 'hash_name'.freeze
  ITEM_HASH_BEST_OFFER_KEY       = 'best_offer'.freeze
  ITEM_INFO_HASH_MIN_PRICE_KEY   = 'min_price'.freeze
  HASH_MIN_KEY                        = 'min'.freeze
  HASH_MAX_KEY                        = 'max'.freeze
  HASH_AVERAGE_KEY                    = 'average'.freeze

  COUNT_FOUND_ITEMS_TEXT         = 'Found %{count_item} new items!'.freeze
  ITEM_CREATED_TEXT              = 'Item created!'.freeze

  LAST_50_PURCHASES_URL          = 'https://market.dota2.net/history/json/'.freeze
  BEST_BUY_OFFER_URL             = 'https://market.dota2.net/api/BestBuyOffer/'\
                                   '%{class_id}_%{instance_id}/?key=%{your_secret_key}'.freeze
  BEST_SELL_OFFER_URL            = 'https://market.dota2.net/api/BestSellOffer/'\
                                   '%{class_id}_%{instance_id}/?key=%{your_secret_key}'.freeze
  DELETE_ORDERS_URL              = 'https://market.dota2.net/api/DeleteOrders/?key=%{your_secret_key}'.freeze
  CREATE_ORDER_URL               = 'https://market.dota2.net/api/ProcessOrder/'\
                                   '%{class_id}/%{instance_id}/%{price}/?key=%{your_secret_key}'.freeze
  ITEM_LINK_URL                  = 'https://market.dota2.net/item/'\
                                   '%{class_id}-%{instance_id}-%{i_market_hash_name}/'.freeze
  NOT_SALE_ITEMS_URL             = 'https://market.dota2.net/api/GetInv/?key=%{your_secret_key}'.freeze
  SALE_ITEMS_URL                 = 'https://market.dota2.net/api/GetMySellOffers/?key=%{your_secret_key}'.freeze
  ITEM_HISTORY_URL               = 'https://market.dota2.net/api/ItemHistory/'\
                                   '%{class_id}_%{instance_id}/?key=%{your_secret_key}'.freeze
  ITEM_INFORMATION_URL           = 'https://market.dota2.net/api/ItemInfo/'\
                                   '%{class_id}_%{instance_id}/ru/?key=%{your_secret_key}'.freeze

end
