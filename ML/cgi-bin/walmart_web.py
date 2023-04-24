"""
# URL : http://localhost:8080/cgi-bin/walmart_web.py
"""
# 모듈 로딩 ---------------------------------------------------
import cgi, sys, codecs, os
import joblib

# WEB 인코딩 설정 ---------------------------------------------
sys.stdout=codecs.getwriter('utf-8')(sys.stdout.detach())

# 함수 선언 --------------------------------------------------
# WEB 페이지 출력 --------------------------------------------
def displayWEB(detect_msg):
    print("Content-Type: text/html; charset=utf-8")
    print("")
    html="""
    <!DOCTYPE html>
    <html lang='en'>
    <head>
        <meta charset="UTF-8">
        <title>월마트 수요 예측</title>
    </head>
    <body align="center">
    <h2> 🏪점포별 수요 예측값 </h2>
    <form>
        <input id="temp" type="text" placeholder="Temperature" name="temp"> &nbsp&nbsp
        <input id="fuel" type="text" placeholder="Fuel Price" name="fuel"> &nbsp&nbsp
        <input id="cpi" type="text" placeholder="CPI" name="cpi"> &nbsp&nbsp
        <input id="unemploy" type="text" placeholder="Unemployment" name="unemploy"> &nbsp&nbsp
        <input id="month" type="text" placeholder="month" name="month"> &nbsp&nbsp <br>
        <input type="submit" value="판정"></br>
        <p><font color=#5882FA>{}</font></p>
    </form></body></html>""".format(detect_msg)
    print(html)

# 판정 --------------------------------------------------------
def predict_demand(temp, fuel, cpi, unemploy, month):
    temp = int(temp)
    fuel = int(fuel)
    cpi = int(cpi)
    unemploy = int(unemploy)
    month = int(month)
        
    return res[0]

# 기능 구현 -----------------------------------------------------
# (1) 학습 데이터 읽기
pklfile = os.path.dirname(__file__) + "/et_model.pkl"
et = joblib.load(pklfile)

# (2) WEB 페이지 <Form> -> <INPUT> 리스트 가져오기
form = cgi.FieldStorage()
temp_value = form.getvalue('temp')
fuel_value = form.getvalue('fuel')
cpi_value = form.getvalue('cpi')
unemploy_value = form.getvalue('unemploy')
month_value = form.getvalue('month')

# (3) 판정 하기
if temp_value is not None and fuel_value is not None and cpi_value is not None and unemploy_value is not None and month_value is not None:
    result = '기온 : {}, 연료 가격 : {}, 소비자물가지수 : {}, 실업률 : {}, 월 : {} 일 때\n 예상되는 수요는 {}원 입니다.'.format(temp_value, fuel_value, cpi_value, unemploy_value, month_value, predict_demand(temp_value, fuel_value, cpi_value, unemploy_value, month_value))
else:
    result ='측정된 결과가 없습니다.'

# (4) WEB 출력하기
displayWEB(result)