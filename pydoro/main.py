#!/usr/bin/env python3
from flask import Flask

app = Flask(__name__)


@app.route('/status')
def app_status():
    return 'ok'


def main():
    app.run(host='0.0.0.0', port=80)


if __name__ == "__main__":
    main()
