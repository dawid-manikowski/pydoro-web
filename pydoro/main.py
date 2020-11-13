#!/usr/bin/env python3
from flask import Flask

app = Flask(__name__)


@app.route('/status')
def app_status():
    return 'ok'


def main():
    app.run()


if __name__ == "__main__":
    main()
