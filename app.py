from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST': 
        mobile_or_email = request.form.get('mobile')
        password = request.form.get('password')
        remember = request.form.get('remember')

        print(f"[LOGIN ATTEMPT] User: {mobile_or_email}, Remember: {bool(remember)}")
 
        return f"<h2 style='color:green;text-align:center;margin-top:50px;'>Welcome{mobile_or_email}! Logged in successfully.</h2>"

    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)