require 'nokogiri'
require 'open-uri'
require 'pry-rails'
require 'pry-byebug'
require 'google_drive'


def one
   # config.jsonを読み込んでセッションを確立
  session = GoogleDrive::Session.from_config("config.json")

# スプレッドシートをURLで取得
  sp=session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1m90K8G1HMaMQivX4jDKMJ-sGBJerRaPXRFb88F1HnaI/edit#gid=0")

# "株価管理"という名前のワークシートを取得
  ws = sp.worksheet_by_title("株価管理")
  tate=2
  company_link=[]
  while tate<=7 do #銘柄数を随時変更する
    @cn=ws[tate,1].to_s
    @index_host="https://m.finance.yahoo.co.jp/stock?code="
    @search_site=@index_host+@cn
    company_link << @search_site
    tate=tate+1
  end
  
  tate2=2
  company_link.each do |url|
    @doc = Nokogiri::HTML(open(url))
    @today_price=@doc.at_css(".priceFin").text
    ws[tate2,8]=@today_price
    @yesterday_price=@doc.css(".stockDetail").css("dd")[3].text
    ws[tate2,7]=@yesterday_price
    ws.save
    tate2=tate2+1
  end
end

one